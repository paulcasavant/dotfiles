#!/bin/zsh

source ~/.zshenv

# Check if Yabai is running
if pgrep -x "yabai" > /dev/null; then
  # If Yabai is running, stop it
  yabai --stop-service
  terminal-notifier -title "yabai" \
                    -message "Stopped"
else
  # If Yabai is not running, start it
  yabai --start-service
  terminal-notifier -title "yabai" \
                    -message "Started"
fi
