#!/bin/zsh

# Check if Firefox is already running
if pgrep -x "firefox" > /dev/null
then
    # Firefox is running, open a new window
    open -na "Firefox" --args --new-window
else
    # Firefox is not running, open it
    open -a "Firefox"
fi

# Wait for a moment to ensure the window has time to open
sleep 0.5

# Focus the Firefox window using yabai
yabai -m window --focus "$(yabai -m query --windows | jq -r '.[] | select(.app == "Firefox") | .id')"