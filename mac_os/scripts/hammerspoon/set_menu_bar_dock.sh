#!/bin/zsh

# Ensure $SCRIPT_PATH gets set
source ~/.zshenv

# Check if argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <hide|show>"
    exit 1
fi

# Function to toggle menu bar and dock visibility
toggle_menu_bar() {
    if [ "$1" = "hide" ]; then
        osascript "$SCRIPT_PATH/hammerspoon/hide_menu_bar_dock.scpt"
    elif [ "$1" = "show" ]; then
        osascript "$SCRIPT_PATH/hammerspoon/show_menu_bar_dock.scpt"
    else
        echo "Invalid argument: $1. Usage: $0 <hide|show>"
        exit 1
    fi
}

# Main script logic
action="$1"
toggle_menu_bar "$action"
