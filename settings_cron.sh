#!/bin/bash
SCRIPT_URL="https://raw.githubusercontent.com/mixmastrbrock/show_mode/main/showmode.sh"
SCRIPT_PATH="showmode.sh"
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
  ./showmode.sh
###--- CRON UPDATE ---###
SCRIPT_URL="https://raw.githubusercontent.com/mixmastrbrock/show_mode/main/showmode_cron.sh"
SCRIPT_PATH="showmode_cron.sh"
if curl --silent --head --fail "$SCRIPT_URL" > /dev/null; then
    curl --silent --output "$SCRIPT_PATH" "$SCRIPT_URL"
    chmod +x "$SCRIPT_PATH"
fi
