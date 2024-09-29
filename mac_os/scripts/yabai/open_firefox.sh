#!/bin/bash

# Check if Firefox is already running
if pgrep -x "firefox" > /dev/null
then
    # Firefox is running, open a new window
    open -na "Firefox" --args --new-window
else
    # Firefox is not running, open it
    open -a "Firefox"
fi
