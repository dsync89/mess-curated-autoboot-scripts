-- trs80_cass.lua

-- Load common autoboot functions
local common_autoboot = dofile("autoboot_scripts/autoboot_common.lua")

-- Script-wide variables
local button = {}
local frame_num = 0

common_autoboot.populate_buttons(button)

-- --- Constants for this specific script ---
local BUTTON_PRESS_DURATION = common_autoboot.DEFAULT_BUTTON_PRESS_DURATION
local CASSETTE_MOTOR_OFF_DELAY_FRAMES = common_autoboot.DEFAULT_CASSETTE_MOTOR_OFF_DELAY_FRAMES

local function boot_default(cassette_handler)
    common_autoboot.type_at_frame(frame_num, "CLOAD\n", 100, BUTTON_PRESS_DURATION)
    common_autoboot.play_cassette_at_frame(frame_num, ":cassette", 200)

    local cassette_load_done = cassette_handler(frame_num, CASSETTE_MOTOR_OFF_DELAY_FRAMES)

    if cassette_load_done then
        emu.keypost('RUN\n')
    end
end

local function create_boot_type_1_sequence(title_to_type) -- New name for clarity
    return function(cassette_handler_arg) -- This is the function that process_frame will call every frame
        common_autoboot.type_at_frame(frame_num, "L\n", 100)
        common_autoboot.type_at_frame(frame_num, "\n", 200)
        common_autoboot.type_at_frame(frame_num, "SYSTEM\n", 300)
        common_autoboot.type_at_frame(frame_num, title_to_type .. "\n", 400)
        common_autoboot.play_cassette_at_frame(frame_num, ":cassette", 500)

        local cassette_load_done = cassette_handler_arg(frame_num, CASSETTE_MOTOR_OFF_DELAY_FRAMES)

        if cassette_load_done then
            emu.keypost('/\n')
        end
    end
end

local function create_boot_type_2_sequence() -- New name for clarity
    return function(cassette_handler_arg) -- This is the function that process_frame will call every frame
        common_autoboot.type_at_frame(frame_num, "L\n", 100)
        common_autoboot.type_at_frame(frame_num, "\n", 200)
        common_autoboot.type_at_frame(frame_num, "CLOAD\n", 300)
        common_autoboot.play_cassette_at_frame(frame_num, ":cassette", 400)

        local cassette_load_done = cassette_handler_arg(frame_num, CASSETTE_MOTOR_OFF_DELAY_FRAMES)

        if cassette_load_done then
            emu.keypost('RUN\n')
        end
    end
end

local function boot_dtrap(cassette_handler)
    common_autoboot.type_at_frame(frame_num, "L\n", 100, BUTTON_PRESS_DURATION)
    common_autoboot.type_at_frame(frame_num, "\n", 200, BUTTON_PRESS_DURATION)
    common_autoboot.type_at_frame(frame_num, "32640\n", 300, BUTTON_PRESS_DURATION)
    common_autoboot.type_at_frame(frame_num, "CLOAD\n", 400, BUTTON_PRESS_DURATION)
    common_autoboot.play_cassette_at_frame(frame_num, ":cassette", 500)

    local cassette_load_done = cassette_handler(frame_num, CASSETTE_MOTOR_OFF_DELAY_FRAMES)

    if cassette_load_done then
        emu.keypost('RUN\n')
    end
end

-- --- Main Script Logic ---

-- Determine the currently loaded software name
local current_software_name = manager.machine.images:at(1).filename

-- Map software names to their respective boot functions
local boot_sequences = {
    adv03 = create_boot_type_1_sequence("MISSIO"),
    adv10 = create_boot_type_1_sequence("SAVAGE"),
    android = create_boot_type_2_sequence(),
    baccarat = create_boot_type_2_sequence(),
    backgamm = create_boot_type_2_sequence(),
    blakjack = create_boot_type_2_sequence(),
    chess = create_boot_type_1_sequence("SARGON"),
    colliss = create_boot_type_2_sequence(),
    cosmic = create_boot_type_1_sequence("COSMIC"),
    craps = create_boot_type_2_sequence(),
    dddd = create_boot_type_1_sequence("DANDEM"),
    defense = create_boot_type_2_sequence("DEFENS"),
    dtrap = boot_dtrap,
    eliza = create_boot_type_1_sequence("ELIZA"),
    env = create_boot_type_1_sequence("ENV"),
    escape = create_boot_type_1_sequence("ESCAPE"),
    galaxy1 = create_boot_type_1_sequence("GALAXY"),
    galaxy2 = create_boot_type_1_sequence("GALAXY"),
    headon = create_boot_type_1_sequence("HEADON"),
    heliko = create_boot_type_1_sequence("HELIKO"),
    hoppy = create_boot_type_1_sequence("HG"),
    invaders = create_boot_type_1_sequence("INVADE"),
    invasion = create_boot_type_1_sequence("INVADE"),
    keno = create_boot_type_2_sequence(),
    kinghill = create_boot_type_1_sequence("R"),
    meteor2 = create_boot_type_1_sequence("METEOR"),
    microply = create_boot_type_2_sequence(),
    penetr = create_boot_type_1_sequence("PENETR"),
    pinball = create_boot_type_2_sequence(),
    pyrmd = create_boot_type_1_sequence("PYRMD"),
    qwatson = create_boot_type_2_sequence(),
    robot = create_boot_type_1_sequence("ROBOT"),
    roulette = create_boot_type_2_sequence(),
    scarfman = create_boot_type_1_sequence("SCARFM"),
    scripsit = create_boot_type_1_sequence("SCRIPS"),
    seadragon = create_boot_type_1_sequence("SEADRA"),
    slot = create_boot_type_2_sequence(),
    spaceinv = create_boot_type_1_sequence("INVADE"),
    spcinv = create_boot_type_1_sequence("SPCINV"),
    spcwarp = create_boot_type_1_sequence("SPWAR"),
    starfi = create_boot_type_1_sequence("STARFI"),
    starsm = create_boot_type_1_sequence("STARSM"),
    startrek = create_boot_type_2_sequence(),
    starwar = create_boot_type_2_sequence(),
    swamp = create_boot_type_1_sequence("SWAMP"),
    taipan = create_boot_type_2_sequence(),
    trollcru = create_boot_type_2_sequence(),
    wheel = create_boot_type_2_sequence(),
    zchess = create_boot_type_1_sequence("ZCHESS"),
    
    ["default"] = boot_default,
}

-- --- Cassette Loading Handler Setup ---
local cassette_handler = common_autoboot.create_cassette_handler(":cassette") 

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
        boot_function(cassette_handler)
    end
end

-- Subscribe to machine frame notifications
subscription = emu.add_machine_frame_notifier(process_frame)