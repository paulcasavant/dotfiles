
local screens = require('screens')
local config = require('config')
local keys = require('keys')
local lgtv = require('lgtv')

----------------------------  ON STARTUP ----------------------------
-- Enable Hammerspoon CLI
hs.ipc.cliInstall()

-- -- On Startup if LGTV Connected -> Normalize Menu Bar and Dock
if lgtv:is_connected() then
  screens.normalize_menu_bar_and_dock()
end

-- Poll keyboard every 1s
hs.timer.doEvery(1, screens.watch_keyboard_set_hdmi)