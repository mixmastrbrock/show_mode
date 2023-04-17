#!/bin/bash
echo "This script will configure your Mac for all needed software and settings for show mode. Ensure you ran this as SUDO!"
read -p "Are you ready to proceed? [yN]?" REPLY
if [[ "$REPLY" =~ ^[Yy]$  ]]; then
   echo "Script will start in 5..."
   sleep 1
   echo "4..."
   sleep 1
   echo "3..."
   sleep 1
   echo "2..."
   sleep 1
   echo "1..."
   sleep 1
else
  echo "Aborting installer"
  exit
fi
###--- HOMEBREW INSTALL ---###
read -p "Do you need to install Homebrew [yN]?" REPLY
if [[ "$REPLY" =~ ^[Yy]$  ]]; then
   echo "Installing Homebrew"
   ./bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Skipping step"
fi
###--- APPLICATION LIST ---###
read -p "Do you need to install applications [yN]?" REPLY
if [[ "$REPLY" =~ ^[Yy]$  ]]; then
  echo "Starting installtion of applications"
  brew install curl
  brew install wget
  brew install ffmpeg
  brew install handbrake
  brew install --cask parsec
  brew install --cask caffeine
  brew install --cask atemosc
  brew install youtube-dl
  brew install --cask elgato-stream-deck
  brew install --cask vlc
  brew install --cask daisydisk
  brew install --cask istat-menus
  brew install rsync
  brew install --cask obs
  brew install --cask qlab
  brew install --cask propresenter
  brew install --cask atext
  brew install mediaconch
  brew install --cask zoom
  brew install --cask 4k-video-downloader
  brew install --cask chromium
  brew install --cask firefox
  brew install --cask iterm2
  brew install --cask microsoft-powerpoint
  #brew install --cask istat-server
  #brew install --cask microsoft-teams
  #brew install --cask microsoft-outlook
  #brew install --cask microsoft-excel
  #brew install --cask microsoft-word
  #brew install --cask microsoft-office
  #brew install --cask discord
  brew install --cask atom
  #brew install --cask sony-ps-remote-play
  #brew install --cask 1password
  #brew install --cask steam
  #brew install --cask dolphin
  clear
  ###--- NON-SCRIPT APPLICATIONS ---###
  echo "Applications Installed. Two pages will open in your browser for additional downloads to be completed."
  sleep 5
  open https://www.blackmagicdesign.com/support/
  open https://bitfocus.io
else
  echo "Skipping step"
fi
###--- SSYTEM SETTINGS ---###
read -p "Do you need to apply system settings [yN]?" REPLY
if [[ "$REPLY" =~ ^[Yy]$  ]]; then
   echo "Now changing system settings"
   mkdir ~/ShowShare/
   sharing -a ~/ShowShare/ -s 010 -e ShowShare -S ShowShare -g 010
   pmset -a displaysleep 0
   pmset -a disksleep 0
   pmset -a sleep 0
   pmset -a womp 1
   pmset -a autorestart 1
   pmset -a powerbutton 0
   systemsetup -setusingnetworktime on
   systemsetup -setcomputersleep never
   systemsetup -setdisplaysleep never
   systemsetup -setharddisksleep never
   systemsetup -setwakeonnetworkaccess on
   systemsetup -setrestartpowerfailure on
   systemsetup -setallowpowerbuttontosleepcomputer off
   systemsetup -setremotelogin -f on
   softwareupdate --schedule off
   softwareupdate -l
   softwareupdate -d
   defaults write com.apple.dock tilesize -integer 16
   killall Dock
   defaults write NSGlobalDomain _HIHideMenuBar -bool true
   killall Finder
else
  echo "Skipping step"
fi
clear
echo "Script complete. That's it. Get to work."
