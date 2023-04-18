#!/bin/bash
echo "This script will configure your Mac for all needed software and settings for show mode."
read -p "Are you ready to proceed? [yN]?" REPLY
if [[ "$REPLY" =~ ^[Yy]$  ]]; then
   echo "Let's begin!"
else
  echo "Aborting installer"
  exit
fi
###--- SCRIPT UPDATE ---###
read -p "Do you want to check for the latest version of this script. If this the first deployment, this is required. [yN?]?" REPLY
if [[ "$REPLY" =~ ^[Yy]$  ]]; then
  echo "Checking..."
  curl https://raw.githubusercontent.com/mixmastrbrock/show_mode/main/wan.sh -o wan.sh
  curl https://raw.githubusercontent.com/mixmastrbrock/show_mode/main/settings.sh -o settings.sh
  chmod +x wan.sh
  chmod +x settings.sh
  ./wan.sh
else
  echo "Skipping step"
  ./wan.sh
fi
./settings.sh
clear
echo "Script complete. That's it. Get to work."
