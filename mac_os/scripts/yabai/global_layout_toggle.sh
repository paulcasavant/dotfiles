#!/bin/bash

# Get all space IDs
spaces=$(yabai -m query --spaces | jq '.[] | .index')

# Initialize a message for notification
notification_message=""

# Loop through each space and toggle its layout, ignoring fullscreen spaces
for space in $spaces; do
  # Check if the space is in fullscreen mode
  current_layout=$(yabai -m query --spaces --space $space | jq -r '.type')
  is_fullscreen=$(yabai -m query --spaces --space $space | jq -r '."is-native-fullscreen"')

  # Skip fullscreen spaces
  if [[ "$is_fullscreen" == "true" ]]; then
    notification_message+="Space $space: Fullscreen\n"
    continue
  fi

  # Toggle between bsp and float
  if [[ "$current_layout" == "bsp" ]]; then
    yabai -m space $space --layout float
    notification_message+="Space $space: Floating\n"
  else
    yabai -m space $space --layout bsp
    notification_message+="Space $space: BSP\n"
  fi
done

# Show a notification with the current layout status for all spaces, excluding fullscreen
osascript -e "display notification \"$notification_message\" with title \"Yabai\""
