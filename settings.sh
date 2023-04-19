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
   osascript -e 'tell application "System Events" to tell appearance preferences to set the picture of the first desktop to "/System/Library/CoreServices/DefaultDesktop.jpg"'
   osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
   osascript -e 'tell application "System Events" to tell notification preferences to set do not disturb to true'
   defaults write com.apple.sound.beep.feedback -bool false
   defaults write "Apple Global Domain" com.apple.swipescrolldirection -bool true
   sudo mdutil -a -i off
   sudo pmset -a sleep 0 disksleep 0 displaysleep 0 womp 1 autorestart 1 powerbutton 0
   sudo systemsetup -setusingnetworktime on
   sudo systemsetup -setremotelogin on
   defaults write com.apple.dock tilesize -integer 16
   killall Dock
   defaults write NSGlobalDomain _HIHideMenuBar -bool false
   killall Finder
   softwareupdate --schedule off
else
  echo "Skipping step"
fi
