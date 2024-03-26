#!/bin/bash
echo "This script will configure your Mac for all needed software and settings for show mode."
###--- CRON UPDATE ---###
while true; do
  PS3="Select an option:"
  options=("Update" "First Time Install" "Refresh Existing Install" "Install Startup Script" "Set desktop background" "Quit")
  select choice in "${options[@]}"; do
    case $choice in
        "Update")
            echo "Updating script"
            ###--- CRON UPDATE ---###
            SCRIPT_URL="https://raw.githubusercontent.com/mixmastrbrock/show_mode/main/showmode_cron.sh"
            SCRIPT_PATH="showmode_cron.sh"
            if curl --silent --head --fail "$SCRIPT_URL" > /dev/null; then
                curl --silent --output "$SCRIPT_PATH" "$SCRIPT_URL"
                chmod +x "$SCRIPT_PATH"
            fi
            ###--- SHOWMODE UPDATE ---###
            SCRIPT_URL="https://raw.githubusercontent.com/mixmastrbrock/show_mode/main/showmode.sh"
            SCRIPT_PATH="showmode.sh"
            if curl --silent --head --fail "$SCRIPT_URL" > /dev/null; then
              curl --silent --output "$SCRIPT_PATH" "$SCRIPT_URL"
              chmod +x "$SCRIPT_PATH"
            fi
            rm -f wan.sh
            rm -f refresh.sh
            rm -f settings.sh
            rm -f settings_cron.sh
            rm -f showmode.plist
            echo "Exiting. Run again for updated version."
            exit 0
            ;;
        "First Time Install")
            echo "First Time Install Running..."
            # Add your code to execute for Option 2
            ###--- HOMEBREW INSTALL ---###
            read -p "Have you installed Homebrew [yN]?" REPLY
            if [[ "$REPLY" =~ ^[Yy]$  ]]; then
               echo "Continuing script..."
            #   ./bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            else
              echo "Please install Hombrew (https://brew.sh) before continuing."
              exit
            fi
            ###--- APPLICATION LIST ---###
            read -p "Install applications [yN]?" REPLY
            if [[ "$REPLY" =~ ^[Yy]$  ]]; then
              echo "Starting installtion of applications"
              brew install --cask iterm2
              brew install dockutil
              brew install wget
              brew install ffmpeg
              brew install handbrake
              brew install --cask google-chrome
              brew install --cask handbrake
              brew install --cask cyberduck
              brew install --cask caffeine
              brew install --cask elgato-stream-deck
              brew install --cask vlc
              brew install --cask obs
              brew install --cask qlab
              brew install --cask propresenter
              brew install --cask atext
              brew install mediaconch
              brew install --cask zoom
              brew install --cask 4k-video-downloader
              brew install --cask firefox
              brew install --cask microsoft-powerpoint
              brew install --cask microsoft-excel
              brew install --cask microsoft-word
              brew install --cash wifiman
              #brew install --cask daisydisk
              #brew install --cask istat-server
              #brew install --cask atom
              #brew install --cask istat-menus
              clear
              ###--- NON-SCRIPT APPLICATIONS ---###
              echo "Applications Installed. Two pages will open in your browser for additional downloads to be completed."
              sleep 2
              open https://www.blackmagicdesign.com/support/
              open https://bitfocus.io
            else
              echo "Skipping step"
            fi
            ###--- SOFTWARE UPDATES ---###
            read -p "Check for software updates [yN]?" REPLY
            if [[ "$REPLY" =~ ^[Yy]$ ]]; then
              softwareupdate -l
              softwareupdate -d
            else
              echo "Skipping step"
            fi
            ###--- PERSONAL MACHINE ADDITIONS ---###
#            read -p "Install personal applications [yN]?" REPLY
#            if [[ "$REPLY" =~ ^[Yy]$  ]]; then
#              echo "Installing additonal applications"
#              brew install --cask microsoft-teams
#              brew install --cask microsoft-outlook
#              brew install --cask microsoft-office
#              brew install --cask discord
#              brew install --cask sony-ps-remote-play
#              brew install --cask 1password
#              brew install --cask steam
#              brew install --cask dolphin
#              brew install --cask parsec
#            else
#              echo "Skipping step"
#            fi
            ###--- WIFI ---###
            read -p "Add common video WiFi networks [yN]?" REPLY
            if [[ "$REPLY" =~ ^[Yy]$ ]]; then
              echo "Adding network..."
              networksetup -addpreferredwirelessnetworkatindex en0 "HMXVideo2_AP" 0 WPA2 "harvestvideo"
              networksetup -addpreferredwirelessnetworkatindex en0 "Lancelot" 0 WPA2 "cobalt42"
              networksetup -addpreferredwirelessnetworkatindex en0 "HP" 0 WPA "hpnkc2013"
            else
              echo "Skipping step"
            fi
            ###--- HOSTNAME ---###
            read -p "Change the hostname [yN]?" REPLY
            if [[ "$REPLY" =~ ^[Yy]$ ]]; then
              read -p "Enter the hostname you want to use: " new_name
              sudo scutil --set ComputerName "$new_name"
              sudo scutil --set HostName "$new_name"
              sudo scutil --set LocalHostName "$new_name"
            else
              echo "Skipping step"
            fi
            ###--- FILE SHARING ---###
            read -p "Enable file sharing between machines [yN?]?" REPLY
            if [[ "$REPLY" =~ ^[Yy]$  ]]; then
              read -p "Enter the folder name you wish to use: " folder
              echo "Adding directory and enabling sharing"
              mkdir ~/$folder/
              sudo sharing -a ~/$folder/ -s "$folder"
              sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.AppleFileServer.plist
              sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.smbd.plist
            else
              echo "Skipping step"
            fi
            ###--- SYSTEM SETTINGS ---###
            read -p "Apply system settings [yN]?" REPLY
            if [[ "$REPLY" =~ ^[Yy]$  ]]; then
               echo "Now changing system settings"
               # Change desktop background to logo
               SCRIPT_URL="https://raw.githubusercontent.com/mixmastrbrock/show_mode/main/Showmode-BG.png"
               SCRIPT_PATH="Showmode-BG.png"
               if curl --silent --head --fail "$SCRIPT_URL" > /dev/null; then
                   curl --silent --output "$SCRIPT_PATH" "$SCRIPT_URL"
                   chmod +x "$SCRIPT_PATH"
               fi
               SCRIPT_URL="https://raw.githubusercontent.com/mixmastrbrock/show_mode/main/showmode.workflow"
               SCRIPT_PATH="showmode.workflow"
               if curl --silent --head --fail "$SCRIPT_URL" > /dev/null; then
                   curl --silent --output "$SCRIPT_PATH" "$SCRIPT_URL"
                   chmod +x "$SCRIPT_PATH"
               fi
               automator -i "showmode-BG.png" ~/showmode.workflow
               # Change User Icons
               SCRIPT_URL="https://raw.githubusercontent.com/mixmastrbrock/show_mode/main/HMX-Play.png"
               SCRIPT_PATH="HMX-Play.png"
               if curl --silent --head --fail "$SCRIPT_URL" > /dev/null; then
                   curl --silent --output "$SCRIPT_PATH" "$SCRIPT_URL"
                   chmod +x "$SCRIPT_PATH"
               fi
               sudo mv ~/HMX-Play.png /Library/User\ Pictures/
               sudo dscl . delete /Users/$(whoami) JPEGPhoto
               sudo dscl . create /Users/$(whoami) Picture "/Library/User Pictures/HMX-Play.png"
               # Enable dark mode
               osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
               echo "Dark Mode enabled."
               # Enable Do Not Distrub
               osascript -e 'tell application "System Events" to tell notification preferences to set do not disturb to true'
               echo "Do Not Disturb activated."
               # Disable audio level click
               defaults write com.apple.sound.beep.feedback -bool false
               echo "Deactivated audio feedback on level change."
               # Natural scrolling
               defaults write -g com.apple.swipescrolldirection -bool true
               echo "Enabled Natural Scrolling."
               defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
               echo "Enabled Two-Finger Right Click."
               # defaults write com.apple.driver.AppleHIDMouse Button2 -int 2
               # echo "Enabled Bottom-Right Click."
               # Disable Siri
               sudo defaults write /Library/Preferences/com.apple.Siri "VoiceTriggerUserEnabled" -int 0
               sudo launchctl unload -w /System/Library/LaunchAgents/com.apple.Siri.plist 2>/dev/null
               sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.Siri.plist 2>/dev/null
               echo "Disabled Siri."
               # Power Settings
               sudo pmset -a sleep 0
               sudo pmset -a disksleep 0
               sudo pmset -a displaysleep 0
               sudo pmset -a womp 1
               sudo pmset -a autorestart 1
               sudo pmset -a powerbutton 0
               echo "Changed power settings."
               # Enable NTP
               sudo systemsetup -setusingnetworktime on
               # Enable SSH
               sudo systemsetup -setremotelogin on
               echo "Enabled SSH."
               # Hide menu bar
               defaults write NSGlobalDomain _HIHideMenuBar -bool false
               killall Finder
               echo "Hide Menu Bar."
               # Disable automatic software updates
               softwareupdate --schedule off
               # Disable multiple Spaces in Mission Control
               sudo defaults write com.apple.spaces spans-displays -bool false
               echo "Disabled Spaces for external displays."
             else
               echo "Skipping step"
             fi
             read -p "Enable remote desktop (Run only once) [yN]?" REPLY
             if [[ "$REPLY" =~ ^[Yy]$  ]]; then
                echo "Now enabling remote desktop"
               # Enable Remote Management
               sudo defaults write /Library/Preferences/com.apple.RemoteManagement.plist VNCAlwaysStartOnConsole -bool true
               sudo defaults write /Library/Preferences/com.apple.RemoteManagement.plist ManagementADVCOptions -dict-add AppleVNCServerLoadPolicy -int 3
               sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -restart -agent -privs -all -allowAccessFor -allUsers
               sudo sysadminctl -addUser hmx-admin -password HMXLive24! -admin
               SCRIPT_URL="https://raw.githubusercontent.com/mixmastrbrock/show_mode/main/HMX-Play.png"
               SCRIPT_PATH="HMX-Play.png"
               if curl --silent --head --fail "$SCRIPT_URL" > /dev/null; then
                   curl --silent --output "$SCRIPT_PATH" "$SCRIPT_URL"
                   chmod +x "$SCRIPT_PATH"
               fi
               sudo mv ~/HMX-Play.png /Library/User\ Pictures/
               sudo dscl . delete /Users/hmx-admin JPEGPhoto
               sudo dscl . create /Users/hmx-admin Picture "/Library/User Pictures/HMX-Play.png"
               echo "Enabled Remote Desktop"
            else
              echo "Skipping step"
            fi
            read -p "Configure dock [yN]?" REPLY
            if [[ "$REPLY" =~ ^[Yy]$  ]]; then
               echo "Now configuring dock"
               # Backup the current dock preferences
               defaults export com.apple.dock ~/Desktop/dock_backup.plist
               # List of bundle identifiers of apps to remove from the dock
               dockutil -r "/System/Applications/Messages.app" -r "/System/Applications/Mail.app" -r "/System/Applications/Maps.app" -r "/System/Applications/Photos.app" -r "/System/Applications/FaceTime.app" -r "/System/Applications/Contacts.app" -r "/System/Applications/TV.app" -r "/System/Applications/Music.app" -r "/System/Applications/News.app" --no-restart
               dockutil -a "/Applications/Google Chrome.app" --label Chrome --no-restart
               dockutil -a "/Applications/ProPresenter.app" --label ProPresenter --no-restart
               dockutil -a "/Applications/Keynote.app" --label Keynote --no-restart
               dockutil -a "/Applications/Microsoft PowerPoint.app" --label PowerPoint --no-restart
               dockutil -a "/Applications/QLab.app" --label QLab --no-restart
               dockutil -a "/Applications/Cyberduck.app" --label Cyberduck --no-restart
               dockutil -m Chrome -p 3 --no-restart
               dockutil -m ProPresenter -p 4 --no-restart
               dockutil -m Keynote -p 5 --no-restart
               dockutil -m PowerPoint -p 6 --no-restart
               dockutil -m QLab -p 7 --no-restart
               dockutil -m Cyberduck -p 8
               #Change Dock size
               defaults write com.apple.dock tilesize -integer 48
               defaults write com.apple.dock autohide -bool false
               # Restart the dock to apply changes
               killall Dock
               echo "Changed Dock size."
            else
              echo "Skipping step"
            fi
            continue 2
            ;;
        "Refresh Existing Install")
            ###--- REFRESH UPDATE---###
            #!/bin/bash
            brew upgrade
            ###--- APPLICATION LIST ---###
            read -p "Check for new applications [yN]?" REPLY
            if [[ "$REPLY" =~ ^[Yy]$ ]]; then
              echo "Checking for new applications..."
              brew install dockutil
              brew install wget
              brew install --cask handbrake
              brew install --cask cyberduck
              brew install --cask caffeine
              brew install --cask vlc
              brew install --cask microsoft-excel
              brew install --cask microsoft-word
              brew install --cask wifiman
            else
              echo "Skipping step"
            fi
            ###--- SOFTWARE UPDATES ---###
            read -p "Check for software updates [yN]?" REPLY
            if [[ "$REPLY" =~ ^[Yy]$ ]]; then
              softwareupdate -l
              softwareupdate -d
            else
              echo "Skipping step"
            fi
            ###--- HOSTNAME ---###
            read -p "Change the hostname [yN]?" REPLY
            if [[ "$REPLY" =~ ^[Yy]$ ]]; then
              read -p "Enter the hostname you want to use: " new_name
              sudo scutil --set ComputerName "$new_name"
              sudo scutil --set HostName "$new_name"
              sudo scutil --set LocalHostName "$new_name"
            else
              echo "Skipping step"
            fi
            ###--- SYSTEM SETTINGS ---###
            read -p "Apply system settings [yN]?" REPLY
            if [[ "$REPLY" =~ ^[Yy]$  ]]; then
               echo "Now changing system settings"
               # Enable dark mode
               osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
               echo "Dark Mode enabled."
               # Enable Do Not Distrub
               osascript -e 'tell application "System Events" to tell notification preferences to set do not disturb to true'
               echo "Do Not Disturb activated."
               # Disable audio level click
               defaults write com.apple.sound.beep.feedback -bool false
               echo "Deactivated audio feedback on level change."
               # Natural scrolling
               defaults write -g com.apple.swipescrolldirection -bool true
               echo "Enabled Natural Scrolling."
               defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
               echo "Enabled Two-Finger Right Click."
               # defaults write com.apple.driver.AppleHIDMouse Button2 -int 2
               # echo "Enabled Bottom-Right Click."
               # Disable Siri
               sudo defaults write /Library/Preferences/com.apple.Siri "VoiceTriggerUserEnabled" -int 0
               sudo launchctl unload -w /System/Library/LaunchAgents/com.apple.Siri.plist 2>/dev/null
               sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.Siri.plist 2>/dev/null
               echo "Disabled Siri."
               # Power Settings
               sudo pmset -a sleep 0
               sudo pmset -a disksleep 0
               sudo pmset -a displaysleep 0
               sudo pmset -a womp 1
               sudo pmset -a autorestart 1
               sudo pmset -a powerbutton 0
               echo "Changed power settings."
               # Enable NTP
               sudo systemsetup -setusingnetworktime on
               # Enable SSH
               sudo systemsetup -setremotelogin on
               echo "Enabled SSH."
               # Hide menu bar
               defaults write NSGlobalDomain _HIHideMenuBar -bool false
               killall Finder
               echo "Hide Menu Bar."
               # Disable automatic software updates
               softwareupdate --schedule off
               # Disable multiple Spaces in Mission Control
               sudo defaults write com.apple.spaces spans-displays -bool false
               echo "Disabled Spaces for external displays."
             else
               echo "Skipping step"
             fi
             read -p "Configure dock [yN]?" REPLY
             if [[ "$REPLY" =~ ^[Yy]$  ]]; then
                echo "Now configuring dock"
                # Backup the current dock preferences
                defaults export com.apple.dock ~/Desktop/dock_backup.plist
                # List of bundle identifiers of apps to remove from the dock
                dockutil -r "/System/Applications/Messages.app" -r "/System/Applications/Mail.app" -r "/System/Applications/Maps.app" -r "/System/Applications/Photos.app" -r "/System/Applications/FaceTime.app" -r "/System/Applications/Contacts.app" -r "/System/Applications/TV.app" -r "/System/Applications/Music.app" -r "/System/Applications/News.app" --no-restart
                dockutil -a "/Applications/Google Chrome.app" --label Chrome --no-restart
                dockutil -a "/Applications/ProPresenter.app" --label ProPresenter --no-restart
                dockutil -a "/Applications/Keynote.app" --label Keynote --no-restart
                dockutil -a "/Applications/Microsoft PowerPoint.app" --label PowerPoint --no-restart
                dockutil -a "/Applications/QLab.app" --label QLab --no-restart
                dockutil -a "/Applications/Cyberduck.app" --label Cyberduck --no-restart
                dockutil -m Chrome -p 3 --no-restart
                dockutil -m ProPresenter -p 4 --no-restart
                dockutil -m Keynote -p 5 --no-restart
                dockutil -m PowerPoint -p 6 --no-restart
                dockutil -m QLab -p 7 --no-restart
                dockutil -m Cyberduck -p 8
                #Change Dock size
                defaults write com.apple.dock tilesize -integer 48
                defaults write com.apple.dock autohide -bool false
                # Restart the dock to apply changes
                killall Dock
                echo "Changed Dock size."
             else
               echo "Skipping step"
             fi
            continue 2
            ;;
        "Install Startup Script")
            echo "Installing startup script..."
            ###--- CRON UPDATE ---###
            SCRIPT_URL="https://raw.githubusercontent.com/mixmastrbrock/show_mode/main/showmode_cron.sh"
            SCRIPT_PATH="showmode_cron.sh"
            if curl --silent --head --fail "$SCRIPT_URL" > /dev/null; then
                curl --silent --output "$SCRIPT_PATH" "$SCRIPT_URL"
                chmod +x "$SCRIPT_PATH"
            fi
            ###--- PLIST UPDATE ---###
            SCRIPT_URL="https://raw.githubusercontent.com/mixmastrbrock/show_mode/main/showmode.plist"
            SCRIPT_PATH="showmode.plist"
            if curl --silent --head --fail "$SCRIPT_URL" > /dev/null; then
                curl --silent --output "$SCRIPT_PATH" "$SCRIPT_URL"
                chmod +x "$SCRIPT_PATH"
            fi
              mv -f showmode.plist ~/Library/LaunchAgents/
              launchctl load ~/Library/LaunchAgents/showmode.plist
              cron_command="0 0 1 * * ~/settings_cron.sh"
              echo "$cron_command" | crontab -
              "Installed."
            continue 2
            ;;
        "Set desktop background")
        SCRIPT_URL="https://raw.githubusercontent.com/mixmastrbrock/show_mode/main/Showmode-BG.png"
        SCRIPT_PATH="Showmode-BG.png"
        if curl --silent --head --fail "$SCRIPT_URL" > /dev/null; then
            curl --silent --output "$SCRIPT_PATH" "$SCRIPT_URL"
            chmod +x "$SCRIPT_PATH"
        fi
        SCRIPT_URL="https://github.com/mixmastrbrock/show_mode/raw/main/showmode.workflow.zip"
        SCRIPT_PATH="showmode.workflow.zip"
        if curl --silent --head --fail "$SCRIPT_URL" > /dev/null; then
            curl --silent --output "$SCRIPT_PATH" "$SCRIPT_URL"
            chmod +x "$SCRIPT_PATH"
        fi
        unzip showmode.workflow.zip
        rm -f showmode.workflow.zip
        automator -i "showmode-BG.png" ~/showmode.workflow
        ;;
        "Quit")
          exit 0
          ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
  done
done
