#!/bin/bash
echo "This script will configure your Mac for all needed software and settings for show mode."
read -p "Are you ready to proceed? [yN]?" REPLY
if [[ "$REPLY" =~ ^[Yy]$  ]]; then
   echo "Let's begin!"
else
  echo "Aborting installer"
  exit
fi
###--- WAN UPDATE ---###
SCRIPT_URL="https://raw.githubusercontent.com/mixmastrbrock/show_mode/main/wan.sh"
SCRIPT_PATH="wan.sh"
if curl --silent --head --fail "$SCRIPT_URL" > /dev/null; then
  curl --silent --output "$SCRIPT_PATH" "$SCRIPT_URL"
  chmod +x "$SCRIPT_PATH"
fi
###--- SETTINGS UPDATE ---###
SCRIPT_URL="https://raw.githubusercontent.com/mixmastrbrock/show_mode/main/settings.sh"
SCRIPT_PATH="settings.sh"
if curl --silent --head --fail "$SCRIPT_URL" > /dev/null; then
  curl --silent --output "$SCRIPT_PATH" "$SCRIPT_URL"
  chmod +x "$SCRIPT_PATH"
  echo "Updated to the latest version of the script."
fi
./wan.sh
./settings.sh
clear
echo "Script complete. That's it. Get to work."
