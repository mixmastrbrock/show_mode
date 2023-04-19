#!/bin/bash
###--- WIFI ---###
read -p "Do you want to add the video WiFi network [yN]?" REPLY
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
  echo "Adding network..."
  networksetup -addpreferredwirelessnetworkatindex en0 "HMXVideo2_AP" 0 WPA2 "harvestvideo"
  networksetup -addpreferredwirelessnetworkatindex en0 "Lancelot" 0 WPA2 "cobalt42"
else
  echo "Skipping step"
fi
###--- HOSTNAME ---###
read -p "Do you want to change the hostname [yN]?" REPLY
if [["$REPLY" =~ ^[Yy]$ ]]; then
  read -p "Enter the hostname you want to use: " new_name
  sudo scutil --set ComputerName "$new_name"
  sudo scutil --set HostName "$new_name"
  sudo scutil --set LocalHostName "$new_name"
else
  echo "Skipping step"
fi
###--- FILE SHARING ---###
read -p "Do you need file sharing between machines [yN?]?" REPLY
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
read -p "Do you need to apply system settings [yN]?" REPLY
if [[ "$REPLY" =~ ^[Yy]$  ]]; then
   echo "Now changing system settings"
   # Change desktop background to black
   echo -n -e "\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x01\x00\x00\x00\x01\x08\x06\x00\x00\x00\x1F\x15\xC4\x89\x00\x00\x00\x0D\x49\x44\x41\x54\x78\x9C\x63\x00\x01\x00\x01\x05\x00\x00\x00\x00\x1F\xA6\x45\x3D\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82" > /tmp/black.png
   osascript -e 'tell application "System Events" to tell desktops to set picture to "/tmp/black.png"'
   # Enable dark mode
   osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
   # Enable Do Not Distrub
   osascript -e 'tell application "System Events" to tell notification preferences to set do not disturb to true'
   # Disable audio level click
   defaults write com.apple.sound.beep.feedback -bool false
   # Natural scrolling
   defaults write "Apple Global Domain" com.apple.swipescrolldirection -bool true
   # Disable Siri
   sudo defaults write /Library/Preferences/com.apple.Siri "VoiceTriggerUserEnabled" -int 0
   sudo launchctl unload -w /System/Library/LaunchAgents/com.apple.Siri.plist 2>/dev/null
   sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.Siri.plist 2>/dev/null
   # Power Settings
   sudo pmset -a sleep 0 disksleep 0 displaysleep 0 womp 1 autorestart 1 powerbutton 0
   # Enable NTP
   sudo systemsetup -setusingnetworktime on
   # Enable SSH
   sudo systemsetup -setremotelogin on
   # Make Dock small
   defaults write com.apple.dock tilesize -integer 16
   killall Dock
   # Hide menu bar
   defaults write NSGlobalDomain _HIHideMenuBar -bool false
   killall Finder
   # Disable automatic software updates
   softwareupdate --schedule off
else
  echo "Skipping step"
fi
