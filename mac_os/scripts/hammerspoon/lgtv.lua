local LGTVController = {}
LGTVController.__index = LGTVController
local config = require('config')

-- Configuration
local local_config = {
    tv_ip = config.TV_IP_ADDR,
    tv_mac_address = config.TV_MAC_ADDR,
    tv_input = config.LAPTOP_TV_INPUT, -- Input to which your Mac is connected
    switch_input_on_wake = true, -- When computer wakes, switch to `tv_input`
    debug = false, -- Enable debug messages
    control_audio = true, -- Control audio volume/mute with keyboard
    prevent_sleep_when_using_other_input = true, -- Prevent TV sleep if TV is on an input other than `tv_input`
    disable_lgtv = false, -- Disable this script entirely by setting this to true
    -- You can also disable it by creating an empty file  at `~/.disable_lgtv`.

    -- You likely will not need to change anything below this line
    power_off = "power_off",
    screen_off_command = "turn_screen_off",
    screen_on_command = "turn_screen_on",
    key_file_path = "~/.aiopylgtv.sqlite",
    connected_tv_identifiers = config.CONNECTED_TV_IDENTIFIERS,
    bin_path = "~/bin/bscpylgtvcommand",
    wakeonlan_path = "~/bin/wakeonlan",
    laptop_input_id = "com.webos.app." .. (config.LAPTOP_TV_INPUT):lower():gsub("_", ""),
    pc_input_id = "com.webos.app." .. (config.PC_TV_INPUT):lower():gsub("_", ""),
    set_pc_mode_on_wake = true,
    tv_device_name = "MacOS",
    debounce_seconds = 10,
    before_sleep_command = nil,
    after_sleep_command = nil,
    before_wake_command = nil,
    after_wake_command = nil,
}

if local_config.tv_ip == "" or local_config.tv_mac_address == "" then
  print("TV IP and MAC address not set. Please set them first.")
  return
end

-- Utility Functions
local function log_debug(message)
    if local_config.debug then print(message) end
end

local function file_exists(path)
    local file = io.open(path, "r")
    if not file then return false end
    file:close()
    return true
end

local function dump_table(o)
    if type(o) ~= 'table' then return tostring(o) end
    local s = '{ '
    for k, v in pairs(o) do
        s = s .. "[" .. tostring(k) .. "] = " .. dump_table(v) .. ", "
    end
    return s .. '} '
end

-- LGTVController Methods
function LGTVController:new()
    local obj = setmetatable({}, self)
    obj.bin_cmd = local_config.bin_path .. " -p " .. local_config.key_file_path .. " " .. local_config.tv_ip .. " "
    obj.last_wake_execution = 0
    obj.last_sleep_execution = 0
    return obj
end

function LGTVController:execute_command(command, strip)
    strip = strip or false
    local full_command = self.bin_cmd .. command

    local function try_execute()
        log_debug("Executing command: " .. full_command)
        local output, status, _, rc = hs.execute(full_command, 5)
        if rc == 0 then return output end
        log_debug("Command failed or timed out (exit code: " .. rc .. "): " .. full_command)
        log_debug("Command stdout: " .. output)
        return nil
    end

    local output = try_execute()
    if not output then
        hs.timer.usleep(1000000) -- 1 second in microseconds
        log_debug("Retrying command after 1 second delay...")
        output = try_execute()
        if not output then
            return nil
        end
    end

    if strip then
        return output:match("^(.-)%s*$")
    end
    return output
end

function LGTVController:is_connected()
    for _, identifier in ipairs(local_config.connected_tv_identifiers) do
        if hs.screen.find(identifier) then
            return true
        end
    end
    return false
end

function LGTVController:disabled()
    return local_config.disable_lgtv or file_exists("./disable_lgtv") or file_exists(os.getenv('HOME') .. "/.disable_lgtv")
end

function LGTVController:current_app_id()
    return self:execute_command("get_current_app", true)
end

function LGTVController:is_current_audio_device()
    local current_time = os.time()
    if not self.last_audio_device_check or current_time - self.last_audio_device_check >= 10 then
        self.last_audio_device_check = current_time
        self.last_audio_device = false

        local current_audio = hs.audiodevice.current().name
        for _, identifier in ipairs(local_config.connected_tv_identifiers) do
            if current_audio == identifier then
                log_debug(identifier .. " is the current audio device")
                self.last_audio_device = true
                break
            end
        end
        log_debug(current_audio .. " is the current audio device.")
    end
    return self.last_audio_device
end

function LGTVController:get_muted()
    return self:execute_command("get_muted"):trim() == "True"
end

function LGTVController:toggle_mute()
    local muted = self:get_muted()
    local new_muted = not muted
    if self:execute_command("set_mute " .. tostring(new_muted):lower()) then
        log_debug("Set muted to: " .. tostring(new_muted) .. " (was " .. tostring(muted) .. ")")
    end
end

function LGTVController:log_init()
    log_debug("\n\n-------------------- LGTV DEBUG INFO --------------------")
    log_debug("TV input: " .. local_config.tv_input)
    log_debug("Binary path: " .. local_config.bin_path)
    log_debug("Binary command: " .. self.bin_cmd)
    log_debug("App ID: " .. local_config.laptop_input_id)
    log_debug("LGTV Disabled: " .. tostring(self:disabled()))
    if not self:disabled() then
        log_debug(self:execute_command("get_software_info"))
        log_debug("Current app ID: " .. tostring(self:current_app_id()))
        log_debug("Connected screens: " .. dump_table(hs.screen.allScreens()))
        log_debug("TV is connected? " .. tostring(self:is_connected()))
    end
    log_debug("------------------------------------------------------------\n\n")
end

function LGTVController:wake_on_lan()
    if local_config.tv_mac_address ~= "" then
        local command = local_config.wakeonlan_path .. " " .. local_config.tv_mac_address
        hs.execute(command)
        log_debug("Wake on LAN packet sent to " .. local_config.tv_mac_address)
    end
end

function LGTVController:switch_input_to_laptop()
    if self:current_app_id() ~= local_config.laptop_input_id then
        if self:execute_command("launch_app " .. local_config.laptop_input_id) then
            log_debug("Switched TV input to " .. local_config.laptop_input_id)
        end
    end
end

function LGTVController:switch_input_to_pc()
    if self:current_app_id() ~= local_config.pc_input_id then
        if self:execute_command("launch_app " .. local_config.pc_input_id) then
            log_debug("Switched TV input to " .. local_config.pc_input_id)
        end
    end
end

function LGTVController:screen_off()
    self:execute_command(local_config.screen_off_command)
end

function LGTVController:screen_on()
    self:execute_command(local_config.screen_on_command)
end

function LGTVController:power_off()
    self:execute_command(local_config.power_off)
end

-- Event Handlers
function LGTVController:handle_wake_event()
    local current_time = os.time()
    if current_time - self.last_wake_execution < local_config.debounce_seconds then
        log_debug("Skipping wake execution - debounced.")
        return
    end
    self.last_wake_execution = current_time

    if local_config.before_wake_command then
        log_debug("Executing before wake command: " .. local_config.before_wake_command)
        hs.execute(local_config.before_wake_command)
    end

    if local_config.tv_mac_address ~= "" then
        self:wake_on_lan()
    end

    if self:execute_command("turn_screen_on") then
        log_debug("TV screen turned on")
    end

    if self:current_app_id() ~= local_config.laptop_input_id and local_config.switch_input_on_wake then
        if self:execute_command("launch_app " .. local_config.laptop_input_id) then
            log_debug("Switched TV input to " .. local_config.laptop_input_id)
        end
    end

    if local_config.set_pc_mode_on_wake then
        if self:execute_command("set_device_info " .. local_config.tv_input .. " pc '" .. local_config.tv_device_name .. "'") then
            log_debug("Set TV to PC mode")
        end
    end

    if local_config.after_wake_command then
        log_debug("Executing after wake command: " .. local_config.after_wake_command)
        hs.execute(local_config.after_wake_command)
    end
end

function LGTVController:handle_sleep_event()
    local current_time = os.time()
    if current_time - self.last_sleep_execution < local_config.debounce_seconds then
        log_debug("Skipping sleep execution - debounced.")
        return
    end
    self.last_sleep_execution = current_time

    local current_app = tostring(self:current_app_id())

    log_debug("TV is connected and going to sleep")
    log_debug("Current TV input: " .. current_app)
    log_debug("Prevent sleep on other input: " .. tostring(local_config.prevent_sleep_when_using_other_input))
    log_debug("Expected computer input: " .. local_config.tv_input)

    if current_app ~= local_config.laptop_input_id and local_config.prevent_sleep_when_using_other_input then
        log_debug("TV is on another input (" .. current_app .. "). Skipping power off.")
        return
    end

    if local_config.before_sleep_command then
        log_debug("Executing before sleep command: " .. local_config.before_sleep_command)
        hs.execute(local_config.before_sleep_command)
    end

    if self:execute_command(local_config.screen_off_command) then
        log_debug("TV screen turned off with command: " .. local_config.screen_off_command)
    end

    if local_config.after_sleep_command then
        log_debug("Executing after sleep command: " .. local_config.after_sleep_command)
        hs.execute(local_config.after_sleep_command)
    end
end

function LGTVController:setup_watchers()
    self.watcher = hs.caffeinate.watcher.new(function(eventType)
        local event_names = {
            "systemDidWake",
            "systemWillSleep",
            "systemWillPowerOff",
            "screensDidSleep",
            "screensDidWake",
            "sessionDidResignActive",
            "sessionDidBecomeActive",
            "screensaverDidStart",
            "screensaverWillStop",
            "screensaverDidStop",
            "screensDidLock",
            "screensDidUnlock"
        }
        local event_name = eventType and event_names[eventType + 1] or "unknown"
        log_debug("Received event: " .. tostring(eventType) .. " (" .. tostring(event_name) .. ")")

        if self:disabled() then
            log_debug("LGTV feature disabled. Skipping event handling.")
            return
        end

        if self:is_connected() then
            if eventType == hs.caffeinate.watcher.screensDidWake or
               eventType == hs.caffeinate.watcher.systemDidWake or
               eventType == hs.caffeinate.watcher.screensDidUnlock then
                self:handle_wake_event()
            elseif eventType == hs.caffeinate.watcher.screensDidSleep or
                   eventType == hs.caffeinate.watcher.systemWillPowerOff then
                self:handle_sleep_event()
            end
        end
    end)

    self.audio_event_tap = hs.eventtap.new(
        {hs.eventtap.event.types.keyDown, hs.eventtap.event.types.systemDefined},
        function(event)
            local system_key = event:systemKey()
            local key_actions = {['SOUND_UP'] = "volume_up", ['SOUND_DOWN'] = "volume_down"}
            local pressed_key = tostring(system_key.key)

            if system_key.down then
                if pressed_key == 'MUTE' then
                    if not self:is_current_audio_device() then return end
                    self:toggle_mute()
                elseif key_actions[pressed_key] then
                    if not self:is_current_audio_device() then return end
                    self:execute_command(key_actions[pressed_key])
                end
            end
        end
    )
end

function LGTVController:start()
    self:log_init()
    print("Starting LGTV watcher...")
    self.watcher:start()

    if local_config.control_audio then
        print("Starting LGTV audio events watcher...")
        self.audio_event_tap:start()
    end
end

-- Initialize and start the controller
local controller = LGTVController:new()
controller:setup_watchers()
controller:start()

return controller