#!/bin/bash
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
   # Change desktop background to black
   #echo -n -e "\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x01\x00\x00\x00\x01\x08\x06\x00\x00\x00\x1F\x15\xC4\x89\x00\x00\x00\x0D\x49\x44\x41\x54\x78\x9C\x63\x00\x01\x00\x01\x05\x00\x00\x00\x00\x1F\xA6\x45\x3D\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82" > /tmp/black.png
   #osascript -e 'tell application "System Events" to tell desktops to set picture to "/tmp/black.png"'
   #echo "Desktop background set to black."
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
read -p "Setup startup script [yN]?" REPLY
if [[ "$REPLY" =~ ^[Yy]$  ]]; then
  ###--- CRON UPDATE ---###
  SCRIPT_URL="https://raw.githubusercontent.com/mixmastrbrock/show_mode/main/settings_cron.sh"
  SCRIPT_PATH="settings_cron.sh"
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
    mv showmode.plist ~/Library/LaunchAgents/
    launchctl load ~/Library/LaunchAgents/showmode.plist
    cron_command="0 0 1 * * ~/settings_cron.sh"
    echo "$cron_command" | crontab -
else
  echo "Skipping step"
fi
