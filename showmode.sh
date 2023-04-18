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
read -p "Do you want to check for the latest version of this script [yN?]? If this the first deployment on hardware, you must answer yes." REPLY
if [[ "$REPLY" =~ ^[Yy]$  ]]; then
  echo "Checking..."
  curl https://raw.githubusercontent.com/mixmastrbrock/show_mode/main/wan.sh -o wan.sh
  chmod +x wan.sh
  ./wan.sh
else
  echo "Skipping step"
fi
./wan.sh
