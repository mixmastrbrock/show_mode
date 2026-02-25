# Show Mode by mixmastrbrock

Show Mode configures a macOS device for live event production use. It installs
required applications via Homebrew and applies system settings optimised for
show environments.

---

## Manual Usage (interactive script)

For one-off setup on a machine you have physical access to:

```sh
curl https://raw.githubusercontent.com/mixmastrbrock/show_mode/main/showmode.sh -o showmode.sh
chmod +x showmode.sh
./showmode.sh
```

Follow the on-screen menu to choose which steps to run.

---

## MDM / Apple Business Manager Deployment

For fleet deployment — enrolling many devices automatically via Apple Business
Manager — the repository includes a deployable `.pkg` built with native macOS
tools (`pkgbuild` / `productbuild`).

### What the package does

| Step | Details |
|------|---------|
| **Pre-install check** | Verifies macOS ≥ 10.15 and warns if offline |
| **Homebrew install** | Installs Homebrew as the logged-in user (`NONINTERACTIVE=1`) |
| **App install** | Installs all production apps via `brew install --cask` |
| **System settings** | Dark mode, power management, SSH, NTP, scrolling, Siri off, etc. |
| **Wi-Fi networks** | Adds HMX preferred networks |
| **Desktop & icon** | Sets HMX background and user avatar |
| **Remote Desktop** | Enables ARD/VNC and creates `hmx-admin` account |
| **Dock** | Removes personal apps, adds production apps, resizes |
| **LaunchDaemon** | Installs `com.hmx.showmode` to re-apply settings on boot & monthly |

### Repository layout

```
show_mode/
├── package/
│   ├── scripts/
│   │   ├── preinstall          # Pre-flight system checks
│   │   └── postinstall         # Main non-interactive configuration
│   └── payload/
│       └── Library/
│           ├── LaunchDaemons/
│           │   └── com.hmx.showmode.plist      # System LaunchDaemon
│           └── Scripts/HMX/
│               └── showmode_cron.sh            # Boot/monthly maintenance
├── build.sh                    # Builds the .pkg (run on macOS)
├── Distribution.xml            # productbuild distribution definition
└── Showmode/
    └── Showmode.pkgproj        # Packages.app GUI project (alternative)
```

### Build requirements

| Tool | How to get |
|------|-----------|
| macOS 10.15+ | — |
| Xcode Command Line Tools | `xcode-select --install` |
| Developer ID Installer cert | Apple Developer account → Certificates |

### Building the package

```sh
# Clone the repo
git clone https://github.com/mixmastrbrock/show_mode.git
cd show_mode

# Make the build script executable
chmod +x build.sh

# Build unsigned (testing / local install only)
./build.sh
# → build/ShowMode-1.0.pkg

# Build signed (required for ABM deployment)
DEVELOPER_ID="Developer ID Installer: Your Name (A1B2C3D4E5)" ./build.sh
```

> **Note:** Only signed + notarized packages can be deployed via ABM/MDM on
> macOS 10.15 and later without disabling Gatekeeper.

### Notarizing the package

After signing, submit to Apple's Notary Service:

```sh
# Store credentials once (app-specific password from appleid.apple.com)
xcrun notarytool store-credentials AC_PASSWORD \
  --apple-id  "you@example.com" \
  --team-id   "A1B2C3D4E5" \
  --password  "xxxx-xxxx-xxxx-xxxx"

# Submit and wait for approval
xcrun notarytool submit build/ShowMode-1.0.pkg \
  --keychain-profile AC_PASSWORD \
  --wait

# Staple the ticket to the package
xcrun stapler staple build/ShowMode-1.0.pkg
```

Alternatively, set all four environment variables before running `build.sh`
and notarization will happen automatically:

```sh
DEVELOPER_ID="Developer ID Installer: Your Name (TEAMID)" \
APPLE_ID="you@example.com" \
APPLE_TEAM_ID="TEAMID" \
NOTARY_KEYCHAIN_PROFILE="AC_PASSWORD" \
./build.sh
```

### Deploying via MDM (Jamf Pro example)

1. Log in to Jamf Pro → **Computers → Management Settings → Packages**
2. Upload `build/ShowMode-1.0.pkg`
3. Create a **Policy** (or use **PreStage Enrollment** for zero-touch)
4. Assign the package to the policy and scope it to your device group
5. Set the trigger to **Enrollment Complete** or **Recurring Check-in**

For other MDM solutions (Mosyle, Kandji, Workspace ONE, etc.) the process is
equivalent — upload the signed `.pkg` and assign it to an enrollment workflow
or device group linked to your ABM account.

### Packages.app (GUI alternative)

Open `Showmode/Showmode.pkgproj` in [Packages.app](http://s.sudre.free.fr/Software/Packages/about.html)
to build the package through a GUI. The project has been updated to use
relative paths so it builds correctly on any machine from the cloned repo.

---

## What You'll Need

1. A macOS machine (10.15 Catalina or later)
2. An admin account (or MDM-managed device with admin rights)
3. An internet connection (Homebrew and app downloads require network access)

---

## Troubleshooting

- **Installation log:** `/var/log/showmode-install.log`
- **Maintenance log:** `/var/log/showmode-cron.log`
- Try running the postinstall script manually as root if something fails during MDM deployment
- Report bugs at https://github.com/mixmastrbrock/show_mode/issues
