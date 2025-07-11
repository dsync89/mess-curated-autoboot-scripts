-- vector06_flop.lua

-- Load common autoboot functions
local common_autoboot = dofile("autoboot_scripts/autoboot_common.lua")

-- Script-wide variables
local button = {}
local frame_num = 0

-- Populate the 'button' table using the common function
common_autoboot.populate_buttons(button)

-- Print the button table contents for debugging
common_autoboot.print_buttons(button)

-- --- Constants for this specific script ---
local BUTTON_PRESS_DURATION = common_autoboot.DEFAULT_BUTTON_PRESS_DURATION

-- --- Game-Specific Boot Sequence Functions ---

-- Boot sequence for "komrab" software
local function boot_komrab()
    common_autoboot.press_and_release(button, frame_num, "AP2", 100, BUTTON_PRESS_DURATION)
    common_autoboot.type_at_frame(frame_num, "KOMRAB\n\n", 300)
end

-- Boot sequence for "cdpacman" software
local function boot_cdpacman()
    common_autoboot.press_and_release(button, frame_num, "AP2", 100, BUTTON_PRESS_DURATION)
    common_autoboot.press_and_release(button, frame_num, "Rus/Lat", 300, BUTTON_PRESS_DURATION)
    common_autoboot.press_and_release(button, frame_num, "2 \"", 600, BUTTON_PRESS_DURATION)
end

-- Boot sequence for "card" software
local function boot_card()
    common_autoboot.press_and_release(button, frame_num, "AP2", 100, BUTTON_PRESS_DURATION)
    common_autoboot.press_and_release(button, frame_num, "Space", 300, BUTTON_PRESS_DURATION)
    common_autoboot.press_and_release(button, frame_num, "Enter", 600, BUTTON_PRESS_DURATION)
end

local function boot_gt()
    common_autoboot.press_and_release(button, frame_num, "AP2", 100, BUTTON_PRESS_DURATION)
    common_autoboot.type_at_frame(frame_num, "GT\n", 800, BUTTON_PRESS_DURATION)
    common_autoboot.type_at_frame(frame_num, "Y\n", 1400, BUTTON_PRESS_DURATION)
end

-- Default boot sequence for software that do not have specific boot sequences
local function boot_default()
    common_autoboot.press_and_release(button, frame_num, "AP2", 100, BUTTON_PRESS_DURATION)
end

-- --- Main Script Logic ---

-- Determine the currently loaded software name
local current_software_name = manager.machine.images:at(2).filename

-- Map software names to their respective boot functions
local boot_sequences = {
    komrab = boot_komrab,
    cdpacman = boot_cdpacman,
    card = boot_card,
    gt = boot_gt,
    ["default"] = boot_default
}

-- MAME machine frame notification callback
local function process_frame()
    frame_num = frame_num + 1

    -- Initial setup/info display at frame 1
    if frame_num == 1 then
        emu.print_info("System Driver: " .. emu.romname())
        emu.print_info("Loaded Software Name (from image filename): " .. current_software_name)

        -- Determine which profile will be used 
        if boot_sequences[current_software_name] then
            emu.print_info("--- Booting using game specific profile: " .. current_software_name .. " ---")
        else
            emu.print_info("--- Booting using default profile ---")
        end        
    end

    -- --- Print current frame number every 100 frames ---
    if frame_num % 100 == 0 then -- The modulo operator (%) gives the remainder of a division
        emu.print_info("Current Frame: " .. frame_num)
    end    

    -- Execute the relevant boot sequence based on the loaded software
    local boot_function = boot_sequences[current_software_name]

    if not boot_function then -- If specific function not found
        boot_function = boot_sequences["default"] -- Assign the default function
    end

    if boot_function then
        boot_function()
    end
end

-- Subscribe to machine frame notifications
subscription = emu.add_machine_frame_notifier(process_frame)