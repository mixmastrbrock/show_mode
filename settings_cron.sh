#!/bin/bash
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
softwareupdate -l
softwareupdate -d
