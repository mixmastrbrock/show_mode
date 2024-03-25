#!/bin/bash
echo "This script will configure your Mac for all needed software and settings for show mode."
read -p "Are you ready to proceed? [yN]?" REPLY
if [[ "$REPLY" =~ ^[Yy]$  ]]; then
   echo "Let's begin!"
else
  echo "Aborting installer"
  exit
fi
# Define the list of options
options=("Update" "First Time Install" "Refresh Existing Install" "Install Startup Script" "Quit")

# Display the menu and get user's choice
while true; do
  select choice in "${options[@]}"; do
    case $choice in
        "Update")
            echo "Updating scripts"
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
            fi
            ###--- CRON UPDATE ---###
            SCRIPT_URL="https://raw.githubusercontent.com/mixmastrbrock/show_mode/main/settings_cron.sh"
            SCRIPT_PATH="settings_cron.sh"
            if curl --silent --head --fail "$SCRIPT_URL" > /dev/null; then
                curl --silent --output "$SCRIPT_PATH" "$SCRIPT_URL"
                chmod +x "$SCRIPT_PATH"
            fi
            ###--- REFRESH UPDATE---###
            echo "Refreshing Existing Install..."
            SCRIPT_URL="https://raw.githubusercontent.com/mixmastrbrock/show_mode/main/refresh.sh"
            SCRIPT_PATH="refresh.sh"
            if curl --silent --head --fail "$SCRIPT_URL" > /dev/null; then
              curl --silent --output "$SCRIPT_PATH" "$SCRIPT_URL"
              chmod +x "$SCRIPT_PATH"
            fi
            ###--- SHOWMODE UPDATE ---###
            SCRIPT_URL="https://raw.githubusercontent.com/mixmastrbrock/show_mode/main/showmode.sh"
            SCRIPT_PATH="showmode.sh"
            if curl --silent --head --fail "$SCRIPT_URL" > /dev/null; then
              curl --silent --output "$SCRIPT_PATH" "$SCRIPT_URL"
              chmod +x "$SCRIPT_PATH"
            fi
            echo "Exiting to refresh scripts..."
            exit 0
            ;;
        "First Time Install")
            echo "First Time Install Running..."
            # Add your code to execute for Option 2
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
            fi
            ./wan.sh
            ./settings.sh
            continue 2
            ;;
        "Refresh Existing Install")
            ###--- REFRESH UPDATE---###
            echo "Refreshing Existing Install..."
            SCRIPT_URL="https://raw.githubusercontent.com/mixmastrbrock/show_mode/main/refresh.sh"
            SCRIPT_PATH="refresh.sh"
            if curl --silent --head --fail "$SCRIPT_URL" > /dev/null; then
              curl --silent --output "$SCRIPT_PATH" "$SCRIPT_URL"
              chmod +x "$SCRIPT_PATH"
            fi
            ./refresh.sh
            continue 2
            ;;
        "Install Startup Script")
            echo "Installing startup script..."
            ###--- CRON UPDATE ---###
            SCRIPT_URL="https://raw.githubusercontent.com/mixmastrbrock/show_mode/main/settings_cron.sh"
            SCRIPT_PATH="settings_cron.sh"
            if curl --silent --head --fail "$SCRIPT_URL" > /dev/null; then
                curl --silent --output "$SCRIPT_PATH" "$SCRIPT_URL"
                chmod +x "$SCRIPT_PATH"
            fi
            ###--- PLIST UPDATE ---###
            SCRIPT_URL="https://raw.githubusercontent.com/mixmastrbrock/show_mode/main/showmode.plist"
            SCRIPT_PATH="showmode.plist"
            if curl --silent --head --fail "$SCRIPT_URL" > /dev/null; then
                curl --silent --output "$SCRIPT_PATH" "$SCRIPT_URL"
                chmod +x "$SCRIPT_PATH"
            fi
              mv showmode.plist ~/Library/LaunchAgents/
              launchctl load ~/Library/LaunchAgents/showmode.plist
              cron_command="0 0 1 * * ~/settings_cron.sh"
              echo "$cron_command" | crontab -
              "Installed."
            continue 2
            ;;
        "Quit")
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
  done
done
read -p "Do you want to restart?[yN]?" REPLY
if [[ "$REPLY" =~ ^[Yy]$  ]]; then
   echo "See you soon!"
   sudo reboot now
else
  echo "That's it! Break a leg."
  exit
fi
