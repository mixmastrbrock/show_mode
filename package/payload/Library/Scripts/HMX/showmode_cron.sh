#!/bin/bash
# =============================================================================
# Show Mode - System Maintenance Script
# =============================================================================
# Installed to: /Library/Scripts/HMX/showmode_cron.sh
# Managed by:   /Library/LaunchDaemons/com.hmx.showmode.plist
#
# Runs at boot and on the 1st of every month as root.
# - Self-updates this script from the GitHub repository
# - Re-applies system-level settings
# - Runs Homebrew upgrade as the logged-in user
# =============================================================================

LOG="/var/log/showmode-cron.log"
exec >> "$LOG" 2>&1

echo ""
echo "=== Show Mode Maintenance: $(date) ==="

# ---------------------------------------------------------------------------
# Self-update this script from the GitHub repository
# ---------------------------------------------------------------------------
SCRIPT_URL="https://raw.githubusercontent.com/mixmastrbrock/show_mode/main/showmode_cron.sh"
SCRIPT_DEST="/Library/Scripts/HMX/showmode_cron.sh"
TMP_SCRIPT="$(mktemp)"

if curl --silent --connect-timeout 10 --fail "$SCRIPT_URL" -o "$TMP_SCRIPT" 2>/dev/null; then
    if [ -s "$TMP_SCRIPT" ]; then
        mv "$TMP_SCRIPT" "$SCRIPT_DEST"
        chmod 755 "$SCRIPT_DEST"
        echo "Script updated from GitHub."
    else
        rm -f "$TMP_SCRIPT"
    fi
else
    rm -f "$TMP_SCRIPT"
    echo "Could not reach GitHub for self-update. Continuing with existing script."
fi

# ---------------------------------------------------------------------------
# Identify the currently logged-in console user
# ---------------------------------------------------------------------------
CURRENT_USER=$(stat -f "%Su" /dev/console 2>/dev/null || echo "")

if [ -z "$CURRENT_USER" ] || [ "$CURRENT_USER" = "root" ] || [ "$CURRENT_USER" = "_mbsetupuser" ]; then
    USER_LOGGED_IN=false
    echo "No standard user logged in. Skipping user-context operations."
else
    USER_LOGGED_IN=true
    USER_UID=$(id -u "$CURRENT_USER")
    echo "Running user-context operations as: $CURRENT_USER"
fi

# ---------------------------------------------------------------------------
# Re-apply system-level settings (root context)
# ---------------------------------------------------------------------------
echo "Re-applying system settings..."

defaults write com.apple.sound.beep.feedback -bool false
defaults write /Library/Preferences/com.apple.Siri VoiceTriggerUserEnabled -int 0
defaults write com.apple.spaces spans-displays -bool false

pmset -a sleep 0
pmset -a disksleep 0
pmset -a displaysleep 0
pmset -a womp 1
pmset -a autorestart 1

# ---------------------------------------------------------------------------
# User-context operations (dark mode, Homebrew upgrade)
# ---------------------------------------------------------------------------
if $USER_LOGGED_IN; then

    # Dark mode
    launchctl asuser "$USER_UID" sudo -u "$CURRENT_USER" \
        osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true' \
        2>/dev/null || true

    # Locate Homebrew
    BREW=""
    for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
        if sudo -u "$CURRENT_USER" "$candidate" --version &>/dev/null 2>&1; then
            BREW="$candidate"
            break
        fi
    done

    if [ -n "$BREW" ]; then
        echo "Running Homebrew upgrade..."
        sudo -u "$CURRENT_USER" "$BREW" upgrade 2>&1 | tail -20
    fi

fi

# ---------------------------------------------------------------------------
# Apple software updates (download only, no auto-install)
# ---------------------------------------------------------------------------
echo "Checking for Apple software updates..."
softwareupdate --list 2>&1 | grep -i "recommended\|important" || true

echo "=== Show Mode Maintenance Complete: $(date) ==="
