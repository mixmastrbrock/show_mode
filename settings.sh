#!/bin/bash
###--- FILE SHARING ---###
read -p "Do you need file sharing between machines [yN?]?" REPLY
if [[ "$REPLY" =~ ^[Yy]$  ]]; then
  echo "Now changing system settings"
  mkdir ~/ShowShare/
  sharing -a ~/ShowShare/ -s 010 -e ShowShare -S ShowShare -g 010
else
  echo "Skipping step"
fi
###--- SYSTEM SETTINGS ---###
read -p "Do you need to apply system settings [yN]?" REPLY
if [[ "$REPLY" =~ ^[Yy]$  ]]; then
   echo "Now changing system settings"
   osascript -e 'tell application "Finder" to set desktop picture to {class:"solid color", color:{0, 0, 0}}'
   sudo pmset -a sleep 0 disksleep 0 displaysleep 0 womp 1 autorestart 1 powerbutton 0
   sudo systemsetup -setusingnetworktime on
   sudo systemsetup -setremotelogin -f on
   defaults write com.apple.dock tilesize -integer 16
   killall Dock
   defaults write NSGlobalDomain _HIHideMenuBar -bool true
   killall Finder
   softwareupdate --schedule off
else
  echo "Skipping step"
fi
