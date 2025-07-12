# MAME Curated Autoboot Scripts

This repository offers a collection of tested Lua autoboot scripts for MAME that I personally wrote, designed to seamlessly launch software from various computer systems that often require different boot sequences. 

All scripts are written and verified against **MAME 0.278 ROM sets**, and their boot sequences is lookup from softlist hash.xml files or community discussions. But it should work other previous MAME romset version as well.

## Key Features:

- Fully Tested: Simply execute with `mame.exe -autoboot_script` arg.
- Modular Design: Common functions are centralized in autoboot_common.lua for easy maintenance and readability.

These lua scripts can also be readily imported using my launchbox plugin [MAME Curated Softlist Importer v1.1.0](https://forums.launchbox-app.com/files/file/5477-mame-curated-softlist-importer/). The plugin will then automatically set the custom command line params for matching softlist names here to each title.

## How to Use

Simply download this repo `git clone` or zip, then extract all to your `MAME_FOLDER/scripts/autoboot_scripts`. 

When loading mame, add the `-autoboot_script` arg that point to where the lua is located that corresponds to the softlist.

E.g.

```
mame.exe <system> -autoboot_script scripts\autoboot_scripts\<lua_script> -cass <software_name>
```

You can also optionally display the interactive lua console window to debug the output by adding the `-console` and `-window` arg. 

E.g.

```
mame.exe <system> -autoboot_script scripts\autoboot_scripts\<lua_script> -console -window -cass <software_name>
```

## Automatically Set Cmd Line Per Title in Launchbox

My Launchbox Plugin can also automatically set the titles to use the autoboot script if it can find a matching lua script for that softlist. Simply check the settings, specify the paths of these scripts, and done!

## Design Principle

The script is designed to be very modularized. Most of the common functions such as print device info, play cassette, press buttons are referred to a library common script `autoboot_common.lua` that each `<softlist>.lua` refer to.

The library aims to encapsulate the complexity of frame time triggerring for various events, so no more specifying convoluted frame number checks, or activating/deactivating cassette throttle as most other autoboot script does.

It is possible to further extend the library into a state machine implementation, but I found it not necessary to automate the boot sequence of these systems as most of them are following the following simple procedure that only differs in the boot commands: 
1. Enter boot command, e.g. `CLOAD`, `LOAD`, `MLOAD`
2. Play tape/cassette
3. Disable frame throttle to speed up the tape loading 
4. Enter post-tape laoding command such as `RUN` if any

## Contributing a New System Softlist

To create for a new lua script for a new system softlist and contributing to this repo, simply copy and paste the template in `templates/cassette.lua` and rename to `<softlistname>.lua`.

Then run the software with `mame.exe` and add `-autoboot_script <path>` and `-console -window`, e.g.

`mame.exe <system> -autoboot_script autoboot_scripts\<lua_script> -console -window -cass <software_name>`

Read the output from `common_autoboot.print_image_info()` which should be printed at the first few lines, and find the `Image Slot` where the sofware is loaded, then set the `CASSETTE_SLOT` from the template to that image slot.

For example:

Booting with `mame.exe lynx128k -autoboot_script autoboot_scripts\camplynx_cass.lua -console -window -cass compass`

```
mame.exe lynx128k -autoboot_script autoboot_scripts\camplynx_cass.lua -console -window -cass compass
       /|  /|    /|     /|  /|    _______
      / | / |   / |    / | / |   /      /
     /  |/  |  /  |   /  |/  |  /  ____/
    /       | /   |  /       | /  /_
   /        |/    | /        |/  __/
  /  /|  /|    /| |/  /|  /|    /____
 /  / | / |   / |    / | / |        /
/ _/  |/  /  /  |___/  |/  /_______/
         /  /
        / _/

mame 0.278
Copyright (C) Nicola Salmoria and the MAME team

Lua 5.4
Copyright (C) Lua.org, PUC-Rio

[MAME]> :: invalid BIOS "0", reverting to default
WARNING: the machine might not run correctly.
MLOAD "COMPASS"
--- Loaded Image Information ---
Total loaded images: 3
  Image 1:
    Device Tag: :cassette
    Filename: compass
    Mounted: nil
    Software Name: N/A
    Is Cassette: nil
    Is Harddisk: nil
  Image 2:
    Device Tag: :fdc:0:525qd
    Filename: N/A
    Mounted: nil
    Software Name: N/A
    Is Cassette: nil
    Is Harddisk: nil
  Image 3:
    Device Tag: :fdc:1:525qd
    Filename: N/A
    Mounted: nil
    Software Name: N/A
    Is Cassette: nil
    Is Harddisk: nil
--- End of Image Information ---
```

The software `compass` is found in `Image 1`, so set the `CASSETTE_SLOT` to `1`. The cassette handler will automatically refer to that slot as well, so no changes are needed there. The slot number for cassette might differ from system to system so always check these!

Define any game specific keys in `boot_sequences` list which defines the boot sequence either per software, or a default ones.

```
local boot_sequences = {
    ['3dmoncrz'] = create_boot_type_1_sequence("3D MONSTER"),
    ['6845p'] = create_boot_type_2_sequence("6845P"),
    ...
```

## Autoboot Sequence References

Following are the references that discuss the boot sequence for various systems which the lua script uses:

**System Specific**
- Amstrad CPC `cpc464`: https://www.cpcwiki.eu/forum/technical-support/unknown-command/
- Camputer Lynx `lynx128k`: https://forums.launchbox-app.com/topic/79355-camputer-lynx/
- EACA Colour Genie `cgenie`: https://forums.launchbox-app.com/topic/79552-eaca-colour-genie-mame-problem/

**Compilation**
- Autoboot Command / Script for MAME SWL (Computer Systems) - https://forums.launchbox-app.com/topic/54987-autoboot-command-script-for-mame-swl-computer-systems/


## Disclaimer

Inspired and based upon some of the scripts from https://github.com/Bob-Z/RandoMame