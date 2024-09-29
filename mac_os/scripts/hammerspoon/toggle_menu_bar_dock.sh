#!/bin/zsh

source ~/.zshenv

# Check the current state of the menu bar hiding setting
menu_bar_state=$(defaults read NSGlobalDomain _HIHideMenuBar)

# If the menu bar is set to hide, show menu bar and dock; otherwise hide them
if [ "$menu_bar_state" -eq 1 ]; then
    osascript "$SCRIPT_PATH/hammerspoon/show_menu_bar_dock.scpt"
else
    osascript "$SCRIPT_PATH/hammerspoon/hide_menu_bar_dock.scpt"
fi

