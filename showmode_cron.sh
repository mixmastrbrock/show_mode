#!/bin/bash
SCRIPT_URL="https://raw.githubusercontent.com/mixmastrbrock/show_mode/main/showmode.sh"
SCRIPT_PATH="showmode.sh"
if curl --silent --head --fail "$SCRIPT_URL" > /dev/null; then
  curl --silent --output "$SCRIPT_PATH" "$SCRIPT_URL"
  chmod +x "$SCRIPT_PATH"
fi
# Enable dark mode
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
echo "Dark Mode enabled."
# Enable Do Not Distrub
osascript -e 'tell application "System Events" to tell notification preferences to set do not disturb to true'
echo "Do Not Disturb activated."
# Disable audio level click
defaults write com.apple.sound.beep.feedback -bool false
echo "Deactivated audio feedback on level change."
# Enable Natural Scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true
echo "Enabled Natural Scrolling."
# Enable Two-Finger Right-Click
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
# Restart the necessary services to apply changes
killall cfprefsd
killall Dock
brew upgrade
softwareupdate -l
softwareupdate -d
rm -f settings_cron.sh
###--- CRON UPDATE ---###
SCRIPT_URL="https://raw.githubusercontent.com/mixmastrbrock/show_mode/main/showmode_cron.sh"
SCRIPT_PATH="showmode_cron.sh"
if curl --silent --head --fail "$SCRIPT_URL" > /dev/null; then
    curl --silent --output "$SCRIPT_PATH" "$SCRIPT_URL"
    chmod +x "$SCRIPT_PATH"
fi
