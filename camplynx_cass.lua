-- camplynx_cass.lua

-- Load common autoboot functions
local common_autoboot = dofile("autoboot_scripts/autoboot_common.lua")

-- Script-wide variables
local button = {}
local frame_num = 0

-- --- Cassette Loading Handler Setup ---
local CASSETTE_SLOT = 1
local CASSETTE_DEVICE_TAG = manager.machine.images:at(CASSETTE_SLOT).device.tag
local cassette_handler = common_autoboot.create_cassette_handler(CASSETTE_DEVICE_TAG) 

common_autoboot.populate_buttons(button)

common_autoboot.print_image_info()

-- --- Constants for this specific script ---
local BUTTON_PRESS_DURATION = common_autoboot.DEFAULT_BUTTON_PRESS_DURATION
local CASSETTE_MOTOR_OFF_DELAY_FRAMES = common_autoboot.DEFAULT_CASSETTE_MOTOR_OFF_DELAY_FRAMES

local function boot_default(cassette_handler)
    common_autoboot.type_at_frame(frame_num, "\n", 300)
    common_autoboot.type_at_frame(frame_num, "LOAD\n", 400)
    common_autoboot.play_cassette_at_frame(frame_num, CASSETTE_DEVICE_TAG, 500)

    local cassette_load_done = cassette_handler(frame_num, CASSETTE_MOTOR_OFF_DELAY_FRAMES)

    if cassette_load_done then
        -- emu.keypost('RUN\n')
    end
end

local function create_boot_type_1_sequence(title_to_type) 
    return function(cassette_handler_arg)
        common_autoboot.type_at_frame(frame_num, "MLOAD \"" .. title_to_type .. "\"\n", 100)
        common_autoboot.play_cassette_at_frame(frame_num, ":cassette", 200)

        local cassette_load_done = cassette_handler_arg(frame_num, CASSETTE_MOTOR_OFF_DELAY_FRAMES)

        if cassette_load_done then
            -- emu.keypost('/\n')
        end
    end
end

local function create_boot_type_2_sequence(title_to_type) 
    return function(cassette_handler_arg)
        common_autoboot.type_at_frame(frame_num, "LOAD \"" .. title_to_type .. "\"\n", 100)
        common_autoboot.play_cassette_at_frame(frame_num, ":cassette", 200)

        local cassette_load_done = cassette_handler_arg(frame_num, CASSETTE_MOTOR_OFF_DELAY_FRAMES)

        if cassette_load_done then
            emu.keypost('RUN\n')
        end
    end
end

-- --- Main Script Logic ---

-- Determine the currently loaded software name
local current_software_name = manager.machine.images:at(CASSETTE_SLOT).filename

-- Map software names to their respective boot functions
local boot_sequences = {
    ['3dmoncrz'] = create_boot_type_1_sequence("3D MONSTER"),
    ['6845p'] = create_boot_type_2_sequence("6845P"),
    aide = create_boot_type_2_sequence("AIDE"),
    asterix = create_boot_type_2_sequence("ASTERIX"),
    backgmmn = create_boot_type_2_sequence("BACKGAMMON"),
    battlbrk = create_boot_type_2_sequence("BATTLEBRICK"),
    cardindx = create_boot_type_2_sequence("CARD INDEX"),
    centiped = create_boot_type_1_sequence("CENTIPEDE"),
    chopin = create_boot_type_2_sequence("CHOPIN"),
    cinema = create_boot_type_2_sequence("CINEMA"),
    colossal = create_boot_type_2_sequence("COLOSSAL"),
    composer = create_boot_type_2_sequence("COMPOSER"),
    dambustr = create_boot_type_2_sequence("DAM BUSTER"),
    deathball = create_boot_type_2_sequence("DEATHBALL"),
    diggerman = create_boot_type_1_sequence("DIGGERMAN"),
    disassmb = create_boot_type_2_sequence("DESASS"),
    disassmbf = create_boot_type_2_sequence("DES.IMP"),
    dungeon = create_boot_type_2_sequence("DUNGEON"),
    floydbank = create_boot_type_1_sequence("FLOYDS BANK"),
    forest = create_boot_type_2_sequence("THE FOREST"),
    gamepak4 = create_boot_type_1_sequence("GEMPACK 4"),
    genbasic = create_boot_type_2_sequence("GENEBASIC"),
    gencarac = create_boot_type_2_sequence("GENECAR"),
    gobblspk = create_boot_type_1_sequence("SPOOK"),
    gridtrap = create_boot_type_2_sequence("GRIDTRAP"),
    hangman = create_boot_type_2_sequence("HANGMAN"),
    hilo = create_boot_type_2_sequence("CARDS"),
    inteltab = create_boot_type_2_sequence("INTELTABLYNX"),
    invaders = create_boot_type_1_sequence("INVADERS"),
    labyrinth = create_boot_type_2_sequence("LABYRINTHE"),
    logichess = create_boot_type_1_sequence("ECHECS"),
    mastermnd = create_boot_type_2_sequence("MASTERMIND"),
    mazeman = create_boot_type_1_sequence("MAZEMAN"),
    minedout = create_boot_type_2_sequence("MINEDOUTGOOD"),
    moder80 = create_boot_type_1_sequence("CODE"),
    moonfall = create_boot_type_2_sequence("MOONFALL"),
    moonfallf = create_boot_type_2_sequence("Moonfall2"),
    muncher = create_boot_type_2_sequence("MUNCHER"),
    musicmstr = create_boot_type_2_sequence("MUSIC MASTER"),
    nuclear = create_boot_type_2_sequence("NUCLEAR"),
    numerons = create_boot_type_2_sequence("NUMERONS"),
    ohmummy = create_boot_type_1_sequence("OH MUMMY"),
    panik = create_boot_type_2_sequence("PANIK"),
    pengo = create_boot_type_1_sequence("PENGO"),
    planets = create_boot_type_2_sequence("PLANETS"),
    pwrblastr = create_boot_type_1_sequence("POWER BLASTER"),
    racer = create_boot_type_2_sequence("RACER"),
    risingmn = create_boot_type_2_sequence("CP FP"),
    rocketman = create_boot_type_2_sequence("ROCKETMAN"),
    scrablynx = create_boot_type_2_sequence("SCRABLYNX"),
    scrndmp = create_boot_type_2_sequence("RPENROSE"),
    siege = create_boot_type_1_sequence("SIEGE ATTACK"),
    sairraid = create_boot_type_2_sequence("SUPER AIR RAID"),
    spactrek = create_boot_type_2_sequence("TREK"),
    spellbnd = create_boot_type_2_sequence("SPELLBOUND"),
    starover = create_boot_type_2_sequence("SR"),
    treasisld = create_boot_type_2_sequence("TREASURE"),
    triangle = create_boot_type_2_sequence("BRUMBELOW"),
    tronblkr = create_boot_type_2_sequence("TRON BLOCKER"),
    twinkle = create_boot_type_1_sequence("TWINKLE"),
    wordproc = create_boot_type_1_sequence("LIONTEXT"),
    worm = create_boot_type_2_sequence("THE WORM"),
    wormf = create_boot_type_2_sequence("THE WORM"),
    ynxvader = create_boot_type_1_sequence("YNXVADERS"),
    zombie = create_boot_type_2_sequence("ZombiePanic"),
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

    --- DEBUG: Print current frame number every 100 frames ---
    common_autoboot.debug_frame_num(frame_num)

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