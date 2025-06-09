
local screens = require('screens')
local config = require('config')
local keys = require('keys')
local lgtv = require('lgtv')

----------------------------  ON STARTUP ----------------------------
-- Enable Hammerspoon CLI
hs.ipc.cliInstall()

-- screens.normalize_menu_bar_and_dock()

-- Poll keyboard every 1s
-- hs.timer.doEvery(1, screens.watch_keyboard_set_hdmi)