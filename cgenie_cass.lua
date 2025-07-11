-- cgenie_cass.lua

-- Load common autoboot functions
local common_autoboot = dofile("autoboot_scripts/autoboot_common.lua")

-- Script-wide variables
local button = {}
local frame_num = 0

common_autoboot.populate_buttons(button)

-- Print the button table contents for debugging
-- common_autoboot.print_buttons(button)

-- --- Constants for this specific script ---
local BUTTON_PRESS_DURATION = common_autoboot.DEFAULT_BUTTON_PRESS_DURATION
local CASSETTE_MOTOR_OFF_DELAY_FRAMES = common_autoboot.DEFAULT_CASSETTE_MOTOR_OFF_DELAY_FRAMES

local function boot_default(cassette_handler)
    common_autoboot.type_at_frame(frame_num, "\n", 50, BUTTON_PRESS_DURATION)
    common_autoboot.type_at_frame(frame_num, "CLOAD\n", 100, BUTTON_PRESS_DURATION)
    common_autoboot.play_cassette_at_frame(frame_num, ":cassette", 200)

    local cassette_load_done = cassette_handler(frame_num, CASSETTE_MOTOR_OFF_DELAY_FRAMES)

    if cassette_load_done then
        print("Load done!")
        emu.keypost('RUN\n')
    end
end

local function create_boot_type_1_sequence(title_to_type) -- New name for clarity
    return function(cassette_handler_arg) -- This is the function that process_frame will call every frame
        common_autoboot.type_at_frame(frame_num, "\n", 50)
        common_autoboot.type_at_frame(frame_num, "SYSTEM\n", 150)
        common_autoboot.type_at_frame(frame_num, title_to_type .. "\n", 200)
        common_autoboot.play_cassette_at_frame(frame_num, ":cassette", 300)

        local cassette_load_done = cassette_handler_arg(frame_num, CASSETTE_MOTOR_OFF_DELAY_FRAMES)

        if cassette_load_done then
            emu.keypost('/\n')
        end
    end
end

local function create_boot_type_2_sequence(cassette_handler) -- New name for clarity
    common_autoboot.type_at_frame(frame_num, "\n", 50)
    common_autoboot.type_at_frame(frame_num, "CLOAD\n", 150)
    common_autoboot.play_cassette_at_frame(frame_num, ":cassette", 200)

    local cassette_load_done = cassette_handler(frame_num, CASSETTE_MOTOR_OFF_DELAY_FRAMES)

    if cassette_load_done then
        print("Load done!")
        emu.keypost('RUN\n')
    end
end

-- --- Main Script Logic ---

-- Determine the currently loaded software name
local current_software_name = manager.machine.images:at(1).filename

-- Map software names to their respective boot functions
local boot_sequences = {
    ['3dhaunted'] = create_boot_type_2_sequence,
    a10bomb = create_boot_type_1_sequence("A"),
    abenteue = create_boot_type_2_sequence,
    adressd2 = create_boot_type_2_sequence,
    africa = create_boot_type_2_sequence,
    airaid = create_boot_type_2_sequence,
    alienatt = create_boot_type_2_sequence,
    aliens = create_boot_type_2_sequence,
    andromed = create_boot_type_1_sequence("ANDRO"),
    andromed16 = create_boot_type_1_sequence("ANDRO"),
    astrnaut = create_boot_type_1_sequence("ASTRO"),
    backgamm = create_boot_type_2_sequence,
    baeng = create_boot_type_1_sequence("BAENG"),
    bakpak = create_boot_type_1_sequence("BAKPAK"),
    ballon = create_boot_type_1_sequence("BALLON"),
    bang = create_boot_type_1_sequence("BBBBBB"),
    basicode = create_boot_type_1_sequence("BASICO"),
    basicm = create_boot_type_2_sequence,
    basicp5 = create_boot_type_1_sequence("BPLUS5"),
    baspack = create_boot_type_1_sequence("PACKER"),
    baspacka = create_boot_type_1_sequence("PACKER"),
    benchm = create_boot_type_2_sequence,
    berlineru = create_boot_type_2_sequence,
    blastaro = create_boot_type_1_sequence("BLAST"),
    bluesmak = create_boot_type_2_sequence,
    botschaf = create_boot_type_2_sequence,
    breakout = create_boot_type_1_sequence("BREAK"),
    bruecke = create_boot_type_1_sequence("BRUECK"),
    bumm = create_boot_type_2_sequence,
    casloader = create_boot_type_1_sequence("CAS"),
    caveman = create_boot_type_1_sequence("CAVEMA"),
    chessm = create_boot_type_1_sequence("CHESSM"),
    chomper = create_boot_type_1_sequence("CHOMP"),
    chop83 = create_boot_type_1_sequence("CHOP83"),
    chopper = create_boot_type_1_sequence("CHOP"),
    ciaagent = create_boot_type_2_sequence,
    colasm = create_boot_type_1_sequence("COLASM"),
    colchess = create_boot_type_1_sequence("CHESS"),
    colcom = create_boot_type_1_sequence("COLCOM"),
    coldemo = create_boot_type_2_sequence,
    coldesig = create_boot_type_1_sequence("DESIGN"),
    colemu3w = create_boot_type_2_sequence,
    colforth = create_boot_type_1_sequence("BFORTH"),
    colfortha = create_boot_type_1_sequence("FORTH"),
    colfrog = create_boot_type_1_sequence("FROGGE"),
    colfroga = create_boot_type_1_sequence("FROG"),
    colkong = create_boot_type_1_sequence("KONG32"),
    colkong16 = create_boot_type_1_sequence("KONG"),
    colkong16a = create_boot_type_1_sequence("KONG16"),
    colmon2 = create_boot_type_1_sequence("COLMON"),
    colmon3 = create_boot_type_1_sequence("COLMON"),
    colpasc = create_boot_type_1_sequence("PASCAL"),
    colpont = create_boot_type_2_sequence,
    colqix = create_boot_type_1_sequence("QIX"),
    colrot = create_boot_type_1_sequence("COLROT"),
    colscha = create_boot_type_1_sequence("SARGON"),
    colsch = create_boot_type_1_sequence("SCHACH"),
    colsch16 = create_boot_type_1_sequence("SCHACH"),
    colours = create_boot_type_2_sequence,
    colzap = create_boot_type_1_sequence("COLZAP"),
    cosmic = create_boot_type_1_sequence("COSMIC"),
    cquest1 = create_boot_type_1_sequence("QQQQQQ"),
    cquest2 = create_boot_type_1_sequence("QQQQQQ"),
    cquest3 = create_boot_type_1_sequence("QQQQQQ"),
    cquest4 = create_boot_type_1_sequence("QQQQQQ"),
    cquest4a = create_boot_type_1_sequence("QQQQQQ"),
    cquest6 = create_boot_type_1_sequence("QQQQQQ"),
    crzchase = create_boot_type_2_sequence,
    crzpaint = create_boot_type_1_sequence("PAINT"),
    crzpaintc = create_boot_type_1_sequence("PAINT2"),
    crzpaintca = create_boot_type_1_sequence("CRAZY2"),
    deathsta = create_boot_type_1_sequence("DEATHS"),
    deathtra = create_boot_type_1_sequence("DEATH"),
    defendag = create_boot_type_2_sequence,
    defender = create_boot_type_1_sequence("DFNDR"),
    demond = create_boot_type_2_sequence,
    dezhex = create_boot_type_2_sequence,
    digboy = create_boot_type_1_sequence("DIGBOY"),
    disvilla = create_boot_type_2_sequence,
    dracula = create_boot_type_2_sequence,
    eagle = create_boot_type_1_sequence("EAGLE"),
    eatman = create_boot_type_1_sequence("EATMAN"),
    ebasic = create_boot_type_1_sequence("EBASIC"),
    editdef = create_boot_type_2_sequence,
    editdefa = create_boot_type_2_sequence,
    eis = create_boot_type_1_sequence("EIS"),
    eliminat = create_boot_type_1_sequence("ELIMIN"),
    eliminatg = create_boot_type_1_sequence("ELIMIN"),
    empire = create_boot_type_2_sequence,
    excopy = create_boot_type_1_sequence("EXCOPY"),
    exrevers = create_boot_type_1_sequence("REVERS"),
    extrabas = create_boot_type_2_sequence,
    fastfood = create_boot_type_1_sequence("FAST"),
    firebird = create_boot_type_1_sequence("FIREB"),
    floh = create_boot_type_2_sequence,
    flugsim = create_boot_type_1_sequence("FLUG"),
    flybytes = create_boot_type_2_sequence,
    fraggels = create_boot_type_1_sequence("FRAGGL"),
    galattj = create_boot_type_1_sequence("GALAX"),
    galattk = create_boot_type_1_sequence("GALAX"),
    geniepede = create_boot_type_1_sequence("G"),
    glueck = create_boot_type_1_sequence("GLUECK"),
    gobbleg = create_boot_type_2_sequence,
    gorilla = create_boot_type_1_sequence("GORILL"),
    gorilla32 = create_boot_type_1_sequence("GORILL"),
    gotya = create_boot_type_2_sequence,
    grabit = create_boot_type_1_sequence("GRABIT"),
    grafiked = create_boot_type_1_sequence("GRAFIK"),
    grandpri = create_boot_type_1_sequence("GGGGGG"),
    grauen = create_boot_type_2_sequence,
    hdeath = create_boot_type_2_sequence,
    hektik = create_boot_type_1_sequence("HEKTIK"),
    hektik32 = create_boot_type_1_sequence("HEKTIK"),
    hektike = create_boot_type_1_sequence("HEKTIK"),
    helikopt = create_boot_type_1_sequence("HELIKO"),
    herorun = create_boot_type_2_sequence,
    horror = create_boot_type_2_sequence,
    intboard = create_boot_type_2_sequence,
    invaderd = create_boot_type_2_sequence,
    invaders = create_boot_type_1_sequence("INVADE"),
    invasion = create_boot_type_1_sequence("INVASI"),
    jackpot = create_boot_type_1_sequence("JCKPT"),
    jetset = create_boot_type_1_sequence("JETSET"),
    jpoker = create_boot_type_1_sequence("POKER"),
    jumbo = create_boot_type_1_sequence("JUMBO"),
    kaefer = create_boot_type_1_sequence("KAEFER"),
    king = create_boot_type_2_sequence,
    kniffel = create_boot_type_2_sequence,
    kong = create_boot_type_1_sequence("KONGDM"),
    labyfear = create_boot_type_1_sequence("L"),
    laenquiz = create_boot_type_1_sequence("QUIZ"),
    lasverga = create_boot_type_2_sequence,
    life = create_boot_type_1_sequence("LIFE"),
    linearg = create_boot_type_2_sequence,
    linedraw = create_boot_type_2_sequence,
    listform = create_boot_type_2_sequence,
    lunarlan = create_boot_type_1_sequence("LUNA L"),
    madmen = create_boot_type_1_sequence("MADMEN"),
    maddriv = create_boot_type_1_sequence("MADDRI"),
    madtree = create_boot_type_1_sequence("MADTRE"),
    madven2 = create_boot_type_1_sequence("MMMMMM"),
    magicc = create_boot_type_2_sequence,
    mampf2 = create_boot_type_1_sequence("MAMPF2"),
    mampf2a = create_boot_type_1_sequence("MAMPF2"),
    martianr = create_boot_type_1_sequence("R"),
    mauer = create_boot_type_1_sequence("MAUER"),
    mazechas = create_boot_type_2_sequence,
    mazeman = create_boot_type_1_sequence("MAZEMA"),
    mctapec = create_boot_type_1_sequence("TCOPY"),
    megapede = create_boot_type_1_sequence("MEGA"),
    meteor = create_boot_type_1_sequence("METEOR"),
    meteor32 = create_boot_type_1_sequence("METEOR"),
    micronop = create_boot_type_2_sequence,
    milliped = create_boot_type_1_sequence("MILLIP"),
    monroe = create_boot_type_1_sequence("MONROE"),
    mordzepp = create_boot_type_2_sequence,
    motten = create_boot_type_1_sequence("MOTTEN"),
    musik = create_boot_type_1_sequence("MUSIK"),
    mystad1 = create_boot_type_1_sequence("BATON"),
    mystad2 = create_boot_type_1_sequence("TIMACH"),
    mystad3 = create_boot_type_1_sequence("ARROW1"),
    mystad6 = create_boot_type_1_sequence("CIRCUS"),
    mysttave = create_boot_type_2_sequence,
    natomors = create_boot_type_2_sequence,
    ne555 = create_boot_type_1_sequence("NE555"),
    netzo = create_boot_type_1_sequence("NETZO"),
    nodos80 = create_boot_type_1_sequence("NODOS"),
    numberup = create_boot_type_2_sequence,
    numberupa = create_boot_type_2_sequence,
    orgel = create_boot_type_1_sequence("ORGEL"),
    pacboy = create_boot_type_1_sequence("PACBOY"),
    pacman = create_boot_type_1_sequence("PACMAN"),
    palacem = create_boot_type_1_sequence("PAL"),
    panik = create_boot_type_1_sequence("PANIC"),
    peng = create_boot_type_2_sequence,
    plato = create_boot_type_2_sequence,
    plotter25 = create_boot_type_2_sequence,
    pointcha = create_boot_type_2_sequence,
    polepos = create_boot_type_1_sequence("POLEPO"),
    primzahl = create_boot_type_2_sequence,
    progmod = create_boot_type_2_sequence,
    protheus = create_boot_type_1_sequence("PROTH"),
    psgdemo = create_boot_type_2_sequence,
    puckman = create_boot_type_2_sequence,
    punktej = create_boot_type_1_sequence("PUNKET"),
    punter = create_boot_type_2_sequence,
    qman = create_boot_type_1_sequence("Q*MAN"),
    quandry = create_boot_type_2_sequence,
    quasimo = create_boot_type_1_sequence("QUASI"),
    racing = create_boot_type_2_sequence,
    racingd = create_boot_type_2_sequence,
    realcomp = create_boot_type_1_sequence("RELCOM"),
    roulette = create_boot_type_2_sequence,
    rs232 = create_boot_type_1_sequence("RS232"),
    santapar = create_boot_type_2_sequence,
    saug = create_boot_type_1_sequence("SAUG"),
    schnick = create_boot_type_2_sequence,
    screened = create_boot_type_2_sequence,
    scuttle = create_boot_type_1_sequence("SCUTTL"),
    shaper = create_boot_type_2_sequence,
    shifttra = create_boot_type_2_sequence,
    skramble = create_boot_type_1_sequence("SKRMBL"),
    skramblea = create_boot_type_1_sequence("SKRMBL"),
    snakesn = create_boot_type_2_sequence,
    softschu = create_boot_type_1_sequence("EGPROT"),
    softband = create_boot_type_1_sequence("SOFTBA"),
    sounded = create_boot_type_2_sequence,
    spaceatt = create_boot_type_1_sequence("SPACE"),
    spacefig = create_boot_type_1_sequence("SPACE"),
    spaceman = create_boot_type_1_sequence("SPACE"),
    spacesha = create_boot_type_2_sequence,
    spellpic = create_boot_type_2_sequence,
    spriteed = create_boot_type_2_sequence,
    sstartrk = create_boot_type_2_sequence,
    startrek = create_boot_type_2_sequence,
    stockmar = create_boot_type_2_sequence,
    superbas = create_boot_type_1_sequence("BASCOM"),
    supergen = create_boot_type_2_sequence,
    supergra = create_boot_type_1_sequence("SPLOT"),
    superhrn = create_boot_type_1_sequence("MASTER"),
    swag = create_boot_type_1_sequence("SWAG"),
    synthi = create_boot_type_1_sequence("SYNTHI"),
    synthy = create_boot_type_1_sequence("SYNTH"),
    syscopy = create_boot_type_1_sequence("SYSCOP"),
    tapedisk = create_boot_type_1_sequence("COLOFF"),
    tapeedit = create_boot_type_1_sequence("TAPEDI"),
    tarnsman = create_boot_type_2_sequence,
    tausend = create_boot_type_1_sequence("FUSS"),
    tausenda = create_boot_type_1_sequence("FUSS"),
    terry = create_boot_type_1_sequence("TERRY"),
    theword = create_boot_type_1_sequence("WORD"),
    toadman = create_boot_type_1_sequence("TOAD"),
    tohell = create_boot_type_1_sequence("H"),
    topworld = create_boot_type_2_sequence,
    tracemon = create_boot_type_1_sequence("TRACEM"),
    transist = create_boot_type_2_sequence,
    trashman = create_boot_type_1_sequence("TRASHMAN"),
    triton = create_boot_type_1_sequence("TRIBAT"),
    tron = create_boot_type_1_sequence("TRON"),
    ubootjag = create_boot_type_1_sequence("U-BOOT"),
    uhrzeit = create_boot_type_2_sequence,
    unkchase = create_boot_type_2_sequence,
    unkmulti = create_boot_type_1_sequence("UHRCOP"),
    unksole = create_boot_type_2_sequence,
    utpack2 = create_boot_type_1_sequence("UTPACK"),
    viergewi = create_boot_type_1_sequence("4GEW"),
    vortex = create_boot_type_1_sequence("VORTEX"),
    whatrhym = create_boot_type_2_sequence,
    wordy = create_boot_type_2_sequence,
    wurm = create_boot_type_1_sequence("WURM"),
    zalaga = create_boot_type_1_sequence("ZALAGA"),
    zalagaa = create_boot_type_1_sequence("ZALAGA"),
    zeichen2 = create_boot_type_1_sequence("EDITO2"),
    zeichene = create_boot_type_1_sequence("EDITOR"),
    zeichens = create_boot_type_1_sequence("FONTS"),
}

-- local boot_sequences = {
--     colfrog = create_boot_type_1_sequence("FROGGE"),
--     colfroga = create_boot_type_1_sequence("FROG"),
--     colkong16 = create_boot_type_1_sequence("KONG"),
--     colkong16a = create_boot_type_1_sequence("KONG16"),
--     colpont = create_boot_type_2_sequence,
--     colqix = create_boot_type_1_sequence("QIX"),
--     ["default"] = boot_default,
-- }

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