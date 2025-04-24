local keys = {}

local screens = require("screens")
local config = require('config')
local common = require('common')

local hyper = { "cmd", "ctrl", "alt" }

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Volume Increment with TV as audio device -> Ctrl+Shift+E (TV Volume Increment)
-- Volume Decrement with TV as audio device -> Ctrl+Shift+Q (TV Volume Decrement)
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function keys.start_system_event_watcher()
  if keys.system_event_watcher then
    keys.system_event_watcher:stop()  -- Stop the existing watcher if running
  end

  keys.system_event_watcher = hs.eventtap.new({ hs.eventtap.event.types.systemDefined }, function(event)
    if not screens.lgtv_is_current_audio_device() then
      return
    end

    local system_key = event:systemKey()
    local keys_to_keys = {['SOUND_UP'] = "e", ['SOUND_DOWN'] = "q"}
    local pressed_key = system_key.key

    if system_key.down and keys_to_keys[pressed_key] ~= nil then
      hs.eventtap.event.newKeyEvent({"ctrl", "shift"}, keys_to_keys[pressed_key], true):post()
      hs.eventtap.event.newKeyEvent({"ctrl", "shift"}, keys_to_keys[pressed_key], false):post()
    end
  end)

  keys.system_event_watcher:start()
end
----------------------------------------------------------------------------------------------------

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Hyper+R -> Restart Hammerspoon
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
hs.hotkey.bind(hyper, "h", function()
    hs.reload()
    print("Hammerspoon config reloaded!")
end)
----------------------------------------------------------------------------------------------------

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Hyper+T -> Restart TV
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
hs.hotkey.bind(hyper, "t", function()
  screens.lgtv_exec_command("off")
  common.Sleep(4)
  screens.lgtv_wake_on_lan()
  screens.lgtv_exec_command("on")
  hs.alert.show("Restarted TV")
end)
----------------------------------------------------------------------------------------------------

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Hyper+Esc -> TV Screen Off
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
hs.hotkey.bind(hyper, "escape", function()
  screens.lgtv_exec_command("screenOff")
end)
----------------------------------------------------------------------------------------------------

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Hyper+P -> Turn on TV and Switch Input to PC
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
hs.hotkey.bind(hyper, "p", function()
  screens.lgtv_wake_on_lan()
  screens.lgtv_exec_command("on")
  screens.lgtv_exec_command(string.format("setInput %s", config.PC_TV_INPUT))
end)
----------------------------------------------------------------------------------------------------
---
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Hyper+L -> Turn on TV and Switch Input to Laptop
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
hs.hotkey.bind(hyper, "l", function()
  screens.lgtv_wake_on_lan()
  screens.lgtv_exec_command("on")
  screens.lgtv_exec_command("screenOn")
  screens.lgtv_exec_command(string.format("setInput %s", config.LAPTOP_TV_INPUT))
end)
----------------------------------------------------------------------------------------------------

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Hyper+/ -> Maximum Brightness
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
hs.hotkey.bind(hyper, "/", function()
    hs.execute(string.format("cd %s && ./BetterDisplay set -name='%s' -brightness=100%%", config.BETTER_DISPLAY_FOLDER_PATH, config.CONNECTED_TV_IDENTIFIERS[2]))
    hs.alert.show("100% Brightness")
end)
----------------------------------------------------------------------------------------------------

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Hyper+. -> Brightness +10%
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
hs.hotkey.bind(hyper, '.', function()
    hs.execute(string.format("cd %s && ./BetterDisplay set -name='%s' -offset -brightness=+10%%", config.BETTER_DISPLAY_FOLDER_PATH, config.CONNECTED_TV_IDENTIFIERS[2]))
end)
----------------------------------------------------------------------------------------------------

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Hyper+m -> 25% Brightness (Low)
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
hs.hotkey.bind(hyper, "m", function()
  hs.execute(string.format("cd %s && ./BetterDisplay set -name='%s' -brightness=25%%", config.BETTER_DISPLAY_FOLDER_PATH, config.CONNECTED_TV_IDENTIFIERS[2]))
  hs.alert.show("25% Brightness")
end)
----------------------------------------------------------------------------------------------------

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Hyper+, -> Brightness -10%
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
hs.hotkey.bind(hyper, ',', function()
    hs.execute(string.format("cd %s && ./BetterDisplay set -name='%s' -offset -brightness=-10%%", config.BETTER_DISPLAY_FOLDER_PATH, config.CONNECTED_TV_IDENTIFIERS[2]))
end)
----------------------------------------------------------------------------------------------------

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Hyper+F1 -> Normalize Resolution & HDR On
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
hs.hotkey.bind(hyper, "f1", function()
  hs.execute(string.format("cd %s && ./BetterDisplay set -name='%s' -offset -hdr=on -resolution=2304x1296 -brightness=100%%", config.BETTER_DISPLAY_FOLDER_PATH, config.CONNECTED_TV_IDENTIFIERS[2]))
  hs.alert.show("HDR On")
end)
----------------------------------------------------------------------------------------------------

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Hyper+F2 -> Normalize Resolution & HDR Off
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
hs.hotkey.bind(hyper, "f2", function()
  hs.execute(string.format("cd %s && ./BetterDisplay set -name='%s' -offset -hdr=off -resolution=2304x1296 -brightness=100%%", config.BETTER_DISPLAY_FOLDER_PATH, config.CONNECTED_TV_IDENTIFIERS[2]))
  hs.alert.show("HDR Off")
end)
----------------------------------------------------------------------------------------------------

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Hyper+1 -> Set Audio Input and Output to Audeze Maxwell
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
hs.hotkey.bind(hyper, "1", function()
  hs.execute(string.format("/opt/homebrew/bin/SwitchAudioSource -s '%s';/opt/homebrew/bin/SwitchAudioSource -t input -s '%s'", config.AUDEZE, config.AUDEZE_MIC))
  hs.alert.show("Audio: Audeze Maxwell")
end)
----------------------------------------------------------------------------------------------------

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Hyper+2 -> Set Audio Output to DAC, Input to Webcam Mic
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
hs.hotkey.bind(hyper, "2", function()
  hs.execute(string.format("/opt/homebrew/bin/SwitchAudioSource -s '%s';/opt/homebrew/bin/SwitchAudioSource -t input -s '%s'", config.DAC_NAME, config.WEBCAM_NAME))
  hs.alert.show("Audio: DAC")
end)
----------------------------------------------------------------------------------------------------

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Hyper+3 -> Set Audio Output to Speaker, Input to Webcam Mic
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
hs.hotkey.bind(hyper, "3", function()
  hs.execute(string.format("/opt/homebrew/bin/SwitchAudioSource -s '%s';/opt/homebrew/bin/SwitchAudioSource -t input -s '%s'", config.CONNECTED_TV_IDENTIFIERS[2], config.WEBCAM_NAME))
  hs.alert.show("Audio: Speaker")
end)
----------------------------------------------------------------------------------------------------

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Hyper+F -> Toggle Fn Keys
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
hs.hotkey.bind({"ctrl", "shift"}, "f", function()
  hs.execute(string.format("osascript %s/hammerspoon/toggle_func_keys.scpt", config.SCRIPT_PATH))
  hs.alert.show("Toggle Fn")
end)
--------------------------------------------------------------------------------------------------

return keys