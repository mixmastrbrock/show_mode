#!/bin/bash
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
  brew install --cask istat-server
  brew install --cask atom
  clear
  ###--- NON-SCRIPT APPLICATIONS ---###
  echo "Applications Installed. Two pages will open in your browser for additional downloads to be completed."
  sleep 5
  open https://www.blackmagicdesign.com/support/
  open https://bitfocus.io
else
  echo "Skipping step"
fi
###--- SOFTWARE UPDATES ---###
read -p "Do you want to check for software updates [yN]?" REPLY
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
  softwareupdate -l
  softwareupdate -d
else
  echo "Skipping step"
fi
###--- PERSONAL MACHINE ADDITIONS ---###
read -p "Is this a personal machine [yN]?" REPLY
if [[ "$REPLY" =~ ^[Yy]$  ]]; then
  echo "Installing additonal applications"
  brew install --cask microsoft-teams
  brew install --cask microsoft-outlook
  brew install --cask microsoft-excel
  brew install --cask microsoft-word
  brew install --cask microsoft-office
  brew install --cask discord
  brew install --cask sony-ps-remote-play
  brew install --cask 1password
  brew install --cask steam
  brew install --cask dolphin
  brew install --cask parsec
else
  echo "Skipping step"
fi
