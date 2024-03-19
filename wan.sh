#!/bin/bash
###--- HOMEBREW INSTALL ---###
read -p "Update main script [yN]?" REPLY
if [[ "$REPLY" =~ ^[Yy]$  ]]; then
   echo "Let's begin!"
   SCRIPT_URL="https://raw.githubusercontent.com/mixmastrbrock/show_mode/main/showmode.sh"
   SCRIPT_PATH="wan.sh"
   if curl --silent --head --fail "$SCRIPT_URL" > /dev/null; then
     curl --silent --output "$SCRIPT_PATH" "$SCRIPT_URL"
     chmod +x "$SCRIPT_PATH"
   fi
  echo "New main script loaded"
  exit
else
  echo "Skipping update"
fi
read -p "Have you installed Homebrew [yN]?" REPLY
if [[ "$REPLY" =~ ^[Yy]$  ]]; then
   echo "Continuing script..."
#   ./bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Please install Hombrew (brew.sh) before continuing."
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
read -p "Install personal applications [yN]?" REPLY
if [[ "$REPLY" =~ ^[Yy]$  ]]; then
  echo "Installing additonal applications"
  brew install --cask microsoft-teams
  brew install --cask microsoft-outlook
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
