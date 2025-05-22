local screens = {}
local config = require('config')
local lgtv = require('lgtv')

local LAPTOP_INPUT_APP_ID = "com.webos.app." .. config.LAPTOP_TV_INPUT:lower():gsub("_", "")
local PC_INPUT_APP_ID = "com.webos.app." .. config.PC_TV_INPUT:lower():gsub("_", "")

-- Variable to store the previous keyboard connection state
local previous_keyboard_state = nil

-- Function to switch HDMI input based on whether the keyboard is connected
function screens.watch_keyboard_set_hdmi()
    -- Execute the ioreg command and see if the keyboard manufacturer name is returned
    local output, status, _, _ = hs.execute("ioreg -p IOUSB -w0 | grep " .. config.KEYBOARD_MANUFACTURER)

    -- Determine current state: true if the keyboard is connected, false otherwise
    local current_keyboard_state = (status and output ~= "")

    -- Only switch inputs if the state has changed
    if current_keyboard_state ~= previous_keyboard_state then
        if current_keyboard_state then
            -- If there's any output, switch to laptop input
            lgtv:wake_on_lan()
            lgtv:switch_input_to_laptop()
        else
            -- If there's no output, switch to PC input
            lgtv:switch_input_to_pc()
        end
        -- Update the previous state to the current state
        previous_keyboard_state = current_keyboard_state
    end
end

-- Function to check if the screen is locked using the provided shell command
function screens.is_screen_locked()
  local command = [[
      /bin/bash -c '[ "$(/usr/libexec/PlistBuddy -c "print :IOConsoleUsers:0:CGSSessionScreenIsLocked" /dev/stdin 2>/dev/null <<< "$(ioreg -n Root -d1 -a)")" = "true" ] && echo 0 || echo 1'
  ]]

  local output = hs.execute(command):gsub("%s+", "")
  return output == "0"  -- Returns true if screen is locked
end

-- Function to check menu bar state and execute script if needed
function screens.match_menu_bar_state()
  -- Read the menu bar state
  local menuBarHidden = hs.execute("defaults read NSGlobalDomain _HIHideMenuBar", true)

  -- Trim any whitespace or newline characters
  menuBarHidden = menuBarHidden:gsub("%s+", "")

  if menuBarHidden == "1" and not lgtv:is_connected() then
    -- Execute the shell script to show the menu bar and dock
    hs.execute(string.format("%s/hammerspoon/set_menu_bar_dock.sh show", config.SCRIPT_PATH))
  elseif menuBarHidden == "0" and lgtv:is_connected() then
    -- Execute the shell script to hide the menu bar and dock
    hs.execute(string.format("%s/hammerspoon/set_menu_bar_dock.sh hide", config.SCRIPT_PATH))
  end
end

-- On Wake if LGTV Connected -> Adjust Menu Bar and Dock (if locked retry every 15s)
function screens.normalize_menu_bar_and_dock()
  local retry_timer

  if screens.is_screen_locked() then
    retry_timer = hs.timer.doAfter(15, screens.match_menu_bar_state)
  else
    if retry_timer then
        retry_timer:stop()
    end

    screens.match_menu_bar_state()
  end
end

return screens