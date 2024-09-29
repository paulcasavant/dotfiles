#!/bin/bash

# The direction passed to the script (e.g., "left", "right", "top", "bottom")
direction=$1

# Resize value passed to the script (should be a positive number, like 100)
resize_value=$2

# Attempt to shrink the window in the given direction
yabai -m window --resize $direction:$resize_value || {

  # If shrinking fails, resize the opposite side to make space
  if [[ $direction == "left" ]]; then
    yabai -m window --resize right:$resize_value
  elif [[ $direction == "right" ]]; then
    yabai -m window --resize left:$resize_value
  elif [[ $direction == "top" ]]; then
    yabai -m window --resize bottom:$resize_value
  elif [[ $direction == "bottom" ]]; then
    yabai -m window --resize top:$resize_value
  fi
}
