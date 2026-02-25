#!/bin/bash
# =============================================================================
# Show Mode - Package Build Script
# =============================================================================
# Assembles and builds a signed/unsigned .pkg suitable for deployment via
# MDM solutions paired with Apple Business Manager (ABM).
#
# Requirements:
#   - macOS 10.15 or later
#   - Xcode Command Line Tools  (xcode-select --install)
#   - (Optional) Developer ID Installer certificate in your Keychain
#     for signing + notarization before uploading to your MDM.
#
# Usage:
#   # Unsigned (testing only — cannot be deployed via ABM without signing):
#   ./build.sh
#
#   # Signed (required for ABM deployment):
#   DEVELOPER_ID="Developer ID Installer: Your Name (TEAMID)" ./build.sh
#
#   # Signed + notarize immediately after build:
#   DEVELOPER_ID="Developer ID Installer: Your Name (TEAMID)" \
#   APPLE_ID="you@example.com" \
#   APPLE_TEAM_ID="YOURTEAMID" \
#   NOTARY_KEYCHAIN_PROFILE="AC_PASSWORD" \
#   ./build.sh
# =============================================================================

set -eo pipefail

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
PACKAGE_NAME="ShowMode"
PACKAGE_VERSION="1.0"
PACKAGE_IDENTIFIER="com.hmx.pkg.showmode"
PACKAGE_MIN_OS="10.15"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_STAGING="$SCRIPT_DIR/build/staging"
BUILD_OUTPUT="$SCRIPT_DIR/build"

# Signing / notarization (set via environment variables)
DEVELOPER_ID="${DEVELOPER_ID:-}"
APPLE_ID="${APPLE_ID:-}"
APPLE_TEAM_ID="${APPLE_TEAM_ID:-}"
NOTARY_KEYCHAIN_PROFILE="${NOTARY_KEYCHAIN_PROFILE:-}"

# ---------------------------------------------------------------------------
# Validate environment
# ---------------------------------------------------------------------------
if [ "$(uname)" != "Darwin" ]; then
    echo "Error: This script must be run on macOS."
    exit 1
fi

for tool in pkgbuild productbuild; do
    if ! command -v "$tool" &>/dev/null; then
        echo "Error: '$tool' not found. Install Xcode Command Line Tools:"
        echo "  xcode-select --install"
        exit 1
    fi
done

echo "========================================"
echo " Show Mode Package Builder"
echo " Version : $PACKAGE_VERSION"
echo " ID      : $PACKAGE_IDENTIFIER"
echo " Signed  : ${DEVELOPER_ID:-"No (unsigned)"}"
echo "========================================"
echo ""

# ---------------------------------------------------------------------------
# Clean staging directory
# ---------------------------------------------------------------------------
rm -rf "$BUILD_STAGING"
mkdir -p "$BUILD_STAGING/payload"
mkdir -p "$BUILD_STAGING/scripts"
mkdir -p "$BUILD_OUTPUT"

# ---------------------------------------------------------------------------
# Assemble payload
# ---------------------------------------------------------------------------
echo "[1/5] Assembling package payload..."

# LaunchDaemon
PAYLOAD_DAEMON_DIR="$BUILD_STAGING/payload/Library/LaunchDaemons"
mkdir -p "$PAYLOAD_DAEMON_DIR"
cp "$SCRIPT_DIR/package/payload/Library/LaunchDaemons/com.hmx.showmode.plist" \
   "$PAYLOAD_DAEMON_DIR/"
chmod 644 "$PAYLOAD_DAEMON_DIR/com.hmx.showmode.plist"

# System maintenance script
PAYLOAD_SCRIPTS_DIR="$BUILD_STAGING/payload/Library/Scripts/HMX"
mkdir -p "$PAYLOAD_SCRIPTS_DIR"
cp "$SCRIPT_DIR/package/payload/Library/Scripts/HMX/showmode_cron.sh" \
   "$PAYLOAD_SCRIPTS_DIR/"
chmod 755 "$PAYLOAD_SCRIPTS_DIR/showmode_cron.sh"

# HMX assets (background, icon, workflow) — bundled so installation is
# self-contained and does not require network access for static assets
PAYLOAD_ASSETS_DIR="$BUILD_STAGING/payload/Library/Application Support/HMX"
mkdir -p "$PAYLOAD_ASSETS_DIR"

for asset in Showmode-BG.png HMX-Play.png; do
    if [ -f "$SCRIPT_DIR/$asset" ]; then
        cp "$SCRIPT_DIR/$asset" "$PAYLOAD_ASSETS_DIR/"
    else
        echo "Warning: asset not found — $asset (skipping)"
    fi
done

if [ -d "$SCRIPT_DIR/showmode.workflow" ]; then
    cp -R "$SCRIPT_DIR/showmode.workflow" "$PAYLOAD_ASSETS_DIR/"
else
    echo "Warning: showmode.workflow not found (skipping desktop background setup)"
fi

# ---------------------------------------------------------------------------
# Assemble install scripts
# ---------------------------------------------------------------------------
echo "[2/5] Assembling install scripts..."

cp "$SCRIPT_DIR/package/scripts/preinstall"  "$BUILD_STAGING/scripts/preinstall"
cp "$SCRIPT_DIR/package/scripts/postinstall" "$BUILD_STAGING/scripts/postinstall"
chmod 755 "$BUILD_STAGING/scripts/preinstall" "$BUILD_STAGING/scripts/postinstall"

# ---------------------------------------------------------------------------
# Build component package (.pkg)
# ---------------------------------------------------------------------------
COMPONENT_PKG="$BUILD_OUTPUT/${PACKAGE_NAME}-${PACKAGE_VERSION}-component.pkg"
echo "[3/5] Running pkgbuild..."

pkgbuild \
    --root          "$BUILD_STAGING/payload" \
    --scripts       "$BUILD_STAGING/scripts" \
    --identifier    "$PACKAGE_IDENTIFIER" \
    --version       "$PACKAGE_VERSION" \
    --install-location "/" \
    --ownership     recommended \
    "$COMPONENT_PKG"

# ---------------------------------------------------------------------------
# Build distribution package (.pkg via productbuild)
# ---------------------------------------------------------------------------
DIST_PKG="$BUILD_OUTPUT/${PACKAGE_NAME}-${PACKAGE_VERSION}.pkg"
echo "[4/5] Running productbuild..."

if [ -n "$DEVELOPER_ID" ]; then
    productbuild \
        --distribution "$SCRIPT_DIR/Distribution.xml" \
        --package-path "$BUILD_OUTPUT" \
        --sign         "$DEVELOPER_ID" \
        "$DIST_PKG"
else
    productbuild \
        --distribution "$SCRIPT_DIR/Distribution.xml" \
        --package-path "$BUILD_OUTPUT" \
        "$DIST_PKG"
fi

# Remove the intermediate component package
rm -f "$COMPONENT_PKG"

# ---------------------------------------------------------------------------
# Notarization (optional — requires Apple credentials in env)
# ---------------------------------------------------------------------------
echo "[5/5] Notarization..."

if [ -n "$DEVELOPER_ID" ] && [ -n "$APPLE_ID" ] && [ -n "$APPLE_TEAM_ID" ] && [ -n "$NOTARY_KEYCHAIN_PROFILE" ]; then
    echo "Submitting to Apple Notary Service..."
    xcrun notarytool submit "$DIST_PKG" \
        --apple-id      "$APPLE_ID" \
        --team-id       "$APPLE_TEAM_ID" \
        --keychain-profile "$NOTARY_KEYCHAIN_PROFILE" \
        --wait

    echo "Stapling notarization ticket..."
    xcrun stapler staple "$DIST_PKG"
    echo "Notarization complete."
elif [ -n "$DEVELOPER_ID" ]; then
    echo ""
    echo "Package is signed but NOT notarized."
    echo "Notarize before uploading to your MDM:"
    echo ""
    echo "  # Store app-specific password in Keychain first (one-time):"
    echo "  xcrun notarytool store-credentials AC_PASSWORD \\"
    echo "    --apple-id  'you@example.com' \\"
    echo "    --team-id   'YOURTEAMID' \\"
    echo "    --password  'xxxx-xxxx-xxxx-xxxx'"
    echo ""
    echo "  # Then notarize:"
    echo "  xcrun notarytool submit '$DIST_PKG' \\"
    echo "    --keychain-profile AC_PASSWORD \\"
    echo "    --wait"
    echo ""
    echo "  # Staple:"
    echo "  xcrun stapler staple '$DIST_PKG'"
else
    echo ""
    echo "=========================================================="
    echo " WARNING: Package is UNSIGNED."
    echo " Unsigned packages cannot be deployed via ABM/MDM on"
    echo " modern macOS without disabling Gatekeeper."
    echo ""
    echo " To sign, set DEVELOPER_ID and re-run:"
    echo "   DEVELOPER_ID='Developer ID Installer: Name (TEAMID)' \\"
    echo "   ./build.sh"
    echo "=========================================================="
fi

echo ""
echo "Build complete: $DIST_PKG"
