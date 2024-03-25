#!/bin/bash
###--- SHOWMODE UPDATE ---###
SCRIPT_URL="https://raw.githubusercontent.com/mixmastrbrock/show_mode/main/showmode.sh"
SCRIPT_PATH="showmode.sh"
if curl --silent --head --fail "$SCRIPT_URL" > /dev/null; then
  curl --silent --output "$SCRIPT_PATH" "$SCRIPT_URL"
  chmod +x "$SCRIPT_PATH"
fi
rm -f settings.sh
rm -f showmode.PLIST
exit 0
