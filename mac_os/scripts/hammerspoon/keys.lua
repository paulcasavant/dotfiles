local keys = {}

local screens = require("screens")
local config = require('config')
local common = require('common')
local lgtv = require('lgtv')

local hyper = { "cmd", "ctrl", "alt" }

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
  lgtv:power_off()
  common.Sleep(4)
  lgtv:wake_on_lan()
  hs.alert.show("Restarted TV")
end)
----------------------------------------------------------------------------------------------------

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Hyper+Esc -> TV Screen Off
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
hs.hotkey.bind(hyper, "escape", function()
  lgtv:screen_off()
end)
----------------------------------------------------------------------------------------------------

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Hyper+P -> Turn on TV and Switch Input to PC
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
hs.hotkey.bind(hyper, "p", function()
  lgtv:wake_on_lan()
  lgtv:screen_on()
  lgtv:switch_input_to_pc()
end)
----------------------------------------------------------------------------------------------------
---
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Hyper+L -> Turn on TV and Switch Input to Laptop
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
hs.hotkey.bind(hyper, "l", function()
  lgtv:wake_on_lan()
  lgtv:screen_on()
  lgtv:switch_input_to_laptop()
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
  hs.execute(string.format("cd %s && ./BetterDisplay set -name='%s' -offset -hdr=on -resolution=2048x1152 -brightness=100%%", config.BETTER_DISPLAY_FOLDER_PATH, config.CONNECTED_TV_IDENTIFIERS[2]))
  hs.alert.show("HDR On")
end)
----------------------------------------------------------------------------------------------------

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Hyper+F2 -> Normalize Resolution & HDR Off
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
hs.hotkey.bind(hyper, "f2", function()
  hs.execute(string.format("cd %s && ./BetterDisplay set -name='%s' -offset -hdr=off -resolution=2048x1152 -brightness=100%%", config.BETTER_DISPLAY_FOLDER_PATH, config.CONNECTED_TV_IDENTIFIERS[2]))
  hs.alert.show("HDR Off")
end)
----------------------------------------------------------------------------------------------------

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Hyper+1 -> Set Audio Output to DAC, Input to Webcam Mic
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
hs.hotkey.bind(hyper, "1", function()
  hs.execute(string.format("/opt/homebrew/bin/SwitchAudioSource -s '%s';/opt/homebrew/bin/SwitchAudioSource -t input -s '%s'", config.DAC_NAME, config.WEBCAM_NAME))
  hs.alert.show("Audio: DAC")
end)
----------------------------------------------------------------------------------------------------

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Hyper+2 -> Set Audio Input and Output to Audeze Maxwell
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
hs.hotkey.bind(hyper, "2", function()
  hs.execute(string.format("/opt/homebrew/bin/SwitchAudioSource -s '%s';/opt/homebrew/bin/SwitchAudioSource -t input -s '%s'", config.AUDEZE, config.AUDEZE_MIC))
  hs.alert.show("Audio: Audeze Maxwell")
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