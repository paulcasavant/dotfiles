local screens = {}

local config = require('config')

-- SETTINGS
local SWTICH_INPUT_ON_WAKE = true -- Switch input to Mac when waking the TV
local DEBUG = false  -- If you run into issues, set to true to enable debug messages

-- Warning: --SSL is required!
local LGTV_CMD = config.LGTV_PATH.." --ssl --name "..config.TV_NAME
local LAPTOP_INPUT_APP_ID = "com.webos.app." .. config.LAPTOP_TV_INPUT:lower():gsub("_", "")
local PC_INPUT_APP_ID = "com.webos.app." .. config.PC_TV_INPUT:lower():gsub("_", "")

-- Variable to store the previous keyboard connection state
local previous_keyboard_state = nil

-- Variable to store old TV connection state
local old_lgtv_connected = nil

function screens.lgtv_log_d(message)
  if DEBUG then print(message) end
end

function screens.lgtv_file_exists(name)
  local f=io.open(name,"r")
  if f~=nil then
    io.close(f)
    return true
  else
    return false
  end
end

function screens.lgtv_dump_table(o)
  if type(o) == 'table' then
    local s = '{ '
    for k,v in pairs(o) do
      if type(k) ~= 'number' then k = '"'..k..'"' end
      s = s .. '['..k..'] = ' .. screens.lgtv_dump_table(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

function screens.lgtv_is_connected()
  for i, v in ipairs(config.CONNECTED_TV_IDENTIFIERS) do
    if hs.screen.find(v) ~= nil then
      return true
    end
  end

  return false
end

function screens.lgtv_exec_command(command)
  command = LGTV_CMD.." "..command
  screens.lgtv_log_d("Executing command: "..command)
  return hs.execute(command)
end

function screens.lgtv_wake_on_lan()
  hs.execute(string.format("%s -c \"from wakeonlan import send_magic_packet; send_magic_packet('%s')\"", config.PYTHON_PATH, config.TV_MAC_ADDR)) -- WOL MAC Address
end

function screens.lgtv_is_current_audio_device()
  local current_audio_device = hs.audiodevice.current().name

  for i, v in ipairs(config.CONNECTED_TV_IDENTIFIERS) do
    if current_audio_device == v then
      screens.lgtv_log_d(v.." is the current audio device")
      return true
    end
  end

  screens.lgtv_log_d(current_audio_device.." is the current audio device.")
  return false
end

local function lgtv_current_app_id()
  local foreground_app_info = screens.lgtv_exec_command("getForegroundAppInfo")
  for w in foreground_app_info:gmatch('%b{}') do
    if w:match('\"response\"') then
      local match = w:match('\"appId\"%s*:%s*\"([^\"]+)\"')
      if match then
        return match
      end
    end
  end
end

function screens.lgtv_log_init()
  screens.lgtv_log_d ("TV name: "..config.TV_NAME)
  screens.lgtv_log_d ("TV input: "..config.LAPTOP_TV_INPUT)
  screens.lgtv_log_d ("LGTV path: "..config.LGTV_PATH)
  screens.lgtv_log_d ("LGTV command: "..LGTV_CMD)
  screens.lgtv_log_d (screens.lgtv_exec_command("swInfo"))
  screens.lgtv_log_d (screens.lgtv_exec_command("getForegroundAppInfo"))
  screens.lgtv_log_d("Connected screens: "..screens.lgtv_dump_table(hs.screen.allScreens()))
  screens.lgtv_log_d("TV is connected? "..tostring(screens.lgtv_is_connected()))
end

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
            screens.lgtv_wake_on_lan()
            screens.lgtv_exec_command("startApp " .. LAPTOP_INPUT_APP_ID)
        else
            -- If there's no output, switch to PC input
            screens.lgtv_exec_command("startApp " .. PC_INPUT_APP_ID)
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

  if menuBarHidden == "1" and not screens.lgtv_is_connected() then
    -- Execute the shell script to show the menu bar and dock
    hs.execute(string.format("%s/hammerspoon/set_menu_bar_dock.sh show", config.SCRIPT_PATH))
  elseif menuBarHidden == "0" and screens.lgtv_is_connected() then
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

-- On Wake if LGTV Connected -> Send Magic Packet + LGTV ON + LGTV SCREEN ON + LGTV SET INPUT
function screens.HandleSleepChange(eventType)
  screens.lgtv_log_d("Received event: "..(eventType or ""))

  if (eventType == hs.caffeinate.watcher.screensDidWake or
      eventType == hs.caffeinate.watcher.systemDidWake or
      eventType == hs.caffeinate.watcher.screensDidUnlock) then
    if screens.lgtv_is_connected() then
      screens.lgtv_wake_on_lan()
      screens.lgtv_exec_command("on") -- WOL IP address
      screens.lgtv_exec_command("screenOn") -- turn on screen
      screens.lgtv_log_d("TV was turned on")
      -- hs.execute(config.BSCPY_PATH .. " LGwebOSTV.local set_device_info ".. config.LAPTOP_TV_INPUT .. " pc PC")
      -- hs.execute(config.BSCPY_PATH .. " LGwebOSTV.local set_current_picture_mode hdrStandard")

      if lgtv_current_app_id() ~= LAPTOP_INPUT_APP_ID and SWTICH_INPUT_ON_WAKE then
        screens.lgtv_exec_command("startApp " .. LAPTOP_INPUT_APP_ID)
        screens.lgtv_log_d("TV input switched to " .. LAPTOP_INPUT_APP_ID)
      end
    -- screens.normalize_menu_bar_and_dock()
    end
  end
end

-- On Display Change if LGTV Connected -> Send Magic Packet + LGTV ON + LGTV SCREEN ON + LGTV SET INPUT
function screens.HandleDisplayChange()
  if old_lgtv_connected == nil then
    old_lgtv_connected = screens.lgtv_is_connected()
  end

  local current_lgtv_connected = screens.lgtv_is_connected()

  if current_lgtv_connected ~= old_lgtv_connected then
    if current_lgtv_connected then
      screens.lgtv_wake_on_lan()
      screens.lgtv_exec_command("on") -- WOL IP address
      screens.lgtv_exec_command("screenOn") -- turn on screen
      screens.lgtv_exec_command("setInput " .. config.LAPTOP_TV_INPUT)
      -- screens.normalize_menu_bar_and_dock()
    end
  end

  old_lgtv_connected = current_lgtv_connected
end

return screens