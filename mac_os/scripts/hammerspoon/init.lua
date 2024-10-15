
local screens = require('screens')
local config = require('config')
local keys = require('keys')

----------------------------  ON STARTUP ----------------------------
-- Enable Hammerspoon CLI
hs.ipc.cliInstall()

-- Scan displays
screens.HandleDisplayChange()

-- On Startup if LGTV Connected -> Send Magic Packet (MAC and IP), TV On, TV Screen On, Set TV Input + Normalize Menu Bar and Dock
if screens.lgtv_is_connected() then
  hs.execute(string.format("%s -c \"import wakeonlan; wakeonlan.send_magic_packet('%s')\"", config.PYTHON_PATH, config.TV_MAC_ADDR))
  screens.lgtv_exec_command("on")
  screens.lgtv_exec_command("screenOn")
  hs.execute(string.format("%s on; %s setInput %s", config.LGTV_PATH, config.LGTV_PATH, config.LAPTOP_TV_INPUT))
  -- hs.execute(config.BSCPY_PATH .. " LGwebOSTV.local set_device_info ".. config.LAPTOP_TV_INPUT .. " pc PC")
  -- hs.execute(config.BSCPY_PATH .. " LGwebOSTV.local set_current_picture_mode hdrStandard")
  screens.normalize_menu_bar_and_dock()
end

---------------------------- START WATCHERS ----------------------------
local display_watcher = hs.screen.watcher.newWithActiveScreen(screens.HandleDisplayChange)
display_watcher:start()

local sleep_watcher = hs.caffeinate.watcher.new(screens.HandleSleepChange)
sleep_watcher:start()

keys.start_system_event_watcher()

-- Necessary to restart watchers after waking
local caffeinate_key_watcher = hs.caffeinate.watcher.new(function(eventType)
  if (eventType == hs.caffeinate.watcher.screensDidWake or
      eventType == hs.caffeinate.watcher.systemDidWake or
      eventType == hs.caffeinate.watcher.screensDidUnlock) then

    -- Restart the system event watcher after a delay
    hs.timer.doAfter(2, function()
        keys.start_system_event_watcher()
    end)
  end
end)

-- Start the caffeinate watcher
caffeinate_key_watcher:start()

-- Poll keyboard every 5s
hs.timer.doEvery(2, screens.watch_keyboard_set_hdmi)
