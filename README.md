# magic-castle
    ![Magic Castle Screenshot](screenshots/gameplay.png)
This project is a re-digitization of *Magic Castle*, a previously unreleased game for the ATARI 800 8-bit home computer, designed and programmed by Bruce May in 1983. The source files are based on the scanned artifacts found at [archive.org](https://archive.org/details/magiccastle_atari). An interview with Bruce May regarding the development and fate of *Magic Castle* was recorded for [ANTIC - The ATARI 8-bit Podcast Interview Episode 375](https://ataripodcast.libsyn.com/antic-interview-375-bruce-may-unreleased-magic-castle-game). 

## How to Play
Read the manual. See usage notes below. 

## Project Goal
The goal of this endevour was been to re-implement the game code and binary data exactly as found in the assets available. It is possible the scanned code listings were created prior to the final version of the game. I say this because the documentation and programming notes mention three levels of the Void, however the data dump and BASIC code include only one.

With this goal in mind, a bug is defined as a mismatch between the scanned BASIC listing or binary data dump and the source code files.

# Files
- The releases folder contains an ATR disk image file that can be booted with an ATARI 800 emulator or a real ATARI 800 computer using an emulated or physical floppy disk. 
- The src folder contains the BASIC listing and some reverse-engineering of the binary data. This includes assembly-language subroutines, ANTIC display lists to create custom graphics modes, title screen, map data, string tables for rooms, objects, monsters, etc, allocation tables for object placement, and probability tables used for object and monster placement.
- the obj folder contains the 6502 listing generated by the assembler.
- The docs folder contains a copy of the scanned artifacts found at archive.org. 

## Usage
There are many ATARI 800 emulators so usage is dependent upon your setup. The game requires ATARI BASIC, so you must have a binary image of that cartridge as well as the ROM files for the ATARI's operating system firmware. 

For example with [atari800](https://github.com/atari800/atari800)

    $ atari800 -xl -basic -fullscreen 'Magic Castle (1983)(May, Bruce)(US)[BASIC].atr'

Assuming the emulator is configured correctly, the game should boot to a title screen. Refer to the author's [instruction manual](docs/Magic%20Castle%20Instruction%20Manual.pdf) for the goal and rules of the game.

Note: The game reads the keys so that on a real ATARI there is no need to press the CTRL key when pressing the direction arrows Up, Down, Left, Right. However some ATARI 800 emulators do something similar for the arrow keys typically found on contemporary keyboards and unwittingly undo the game designer's original intent. So you may have to press CTRL + {Up, Down, Left, Right} to move the player when using an emulator or find an emulator setting to prevent this.

## Build Instructions
There is likely no reason to have to build the disk image yourself. Instead grab the .atr file from the releases directory. But just in case...
    $ make (builds from source, resulting in an atr file)

    $ make clean (deletes files created by make, including the .atr file)

    $ make run (launches atari800 emulator with the atr file)

Note: The atari800 emulator's playback feature is used to tokenize the ASCII version of the ATARI BASIC file to "ENTER" an ATASCII file and "SAVE" a tokenized file. The timing of the recorded keystrokes works on my computer but perhaps not on yours. Also the return code of atari800 after this playback is non-zero. So while the tokenized file is successfully created, 'make' halts on the non-zero return code. I have not tried to understand why this is, I simply re-start make, which continues from that step.

## Dependencies

- dir2atr (found in the [AtariSIO](https://github.com/HiassofT/AtariSIO) project)
- atari800 (found at [atari800](https://github.com/atari800/atari800)
- ca65 (included in [cc65](https://github.com/cc65/cc65)
- Perl (used to convert the text version of the author's binary data to a raw binary file)
- C compiler to create a simple ASCII to ATASCII conversion tool

## Acknowledgements
- Bruce May (for creating and sharing his work)
- Kay Savetz (for interviewing Bruce and assisting in the preservation of Magic Castle and numerous other historical artifacts related to the ATARI home computers)
