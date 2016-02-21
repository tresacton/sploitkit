# SploitKit 


SploitKit is a series of scripts I wrote to automate some repetitive or tedius tasks I find I commonly need to perform when writing exploits (specifically: Buffer Overflow Exploits). You're welcome to use these too if you'd like.

## Installation

No installation required (assuming you have Ruby installed - These were tested in Ruby 2.1.1), just download it and chmod the scripts:

    git clone https://github.com/treacton/sploitkit.git
    cd sploitkit
    chmod +x .*   # you trust me, right?? =)

And then execute:

    cd sploitkit
    ./script_name [args may be required depending on the script, but hopefully I've already written a decent help prompt for you]

## Ror Spike 
This script (./ror_spike.rb) is a wrapper for the SPIKE fuzzer. It creates spike templates for multiple commands (as specified in the script), and launch spike for each created file. It logs the variable that caused the crash, the command it was using, and prompts you to add a custom comment to the log. Later, you can navigate to the log and view a history of the crashes you found.

I would have liked to have modified it to wait for you to restart the debugger, then keep trying the rest of the commands, however, I wasn't able to get this working correctly in the time I had to code this. It's on my list of things to do though.

    $ ruby ror_spike.rb 
    +-+-+-+ +-+-+-+-+-+
    |R|o|R| |S|p|i|k|e|
    +-+-+-+ +-+-+-+-+-+
          by T.J Acton
    
    Usage: ror_spike.rb ALL 192.168.1.1 8080
    Three arguments are required - command (e.g. TRUN, or ALL), host, port
    You'll need to edit this script to change the commands available if you're not exploiting vulnserver (line: 25)

#
    $ ruby ror_spike.rb TRUN 192.168.1.1 8080
    +-+-+-+ +-+-+-+-+-+
    |R|o|R| |S|p|i|k|e|
    +-+-+-+ +-+-+-+-+-+
          by T.J Acton
    
    Running: TRUN
    cmd: TRUN - SPK: Total Number of Strings is 681
    cmd: TRUN - SPK: Fuzzing
    cmd: TRUN - SPK: Fuzzing Variable 0:0
    cmd: TRUN - SPK: ror_TRUN.spk : line read=Welcome to my server
    cmd: TRUN - SPK: line read=Type HELP to view commands
    cmd: TRUN - SPK: Fuzzing Variable 0:1
    cmd: TRUN - SPK: ror_TRUN.spk : line read=Welcome to my server
    cmd: TRUN - SPK: Variablesize= 5004
    cmd: TRUN - SPK: tried to send to a closed socket!
    closed socked
    Enter Crash Condition Notes: looks like a vanilla BoF
    [*] Reproduce with: generic_send_tcp 192.168.1.1 8080 ror_TRUN.spk 0 1
    
    
     The crash condition has been logged at: ./ror_spike_notes.txt 
    
     
    -- Terminated. Enjoy getting your shell. --

#
    $ cat ror_spike_notes.txt 
    -----------------------------------------------
    Started script: 1456022260
    Fuzzing Variable 0:1
    tried to send to a closed socket!
    NOTES: looks like a vanilla BoF
    [*] Reproduce with: generic_send_tcp 192.168.1.1 8080 ror_TRUN.spk 0 1


## BadChars

This script (./badchars.rb) is designed to help determine which chars are bad. This script assumes you are working with Olly (or at least, something that results in hex printed in the same format as Olly's binary paste (e.g. 01 0203 04 05 instead of \x01\x02\x03\x04\x05). Remember, I wrote this to suit me. I'm happy to accept pull requests if anybody would like to contribute to making it a little friendlier for use with other debuggers...

Here's an example where the character "\xFF" was removed from our payload in Olly:

    $ ./badchars.rb 
    ___  ____ ___  ____ _  _ ____ ____ ____
    |__] |__| |  \ |    |__| |__| |__/ [__ 
    |__] |  | |__/ |___ |  | |  | |  \ ___]
    
                               by T.J. Acton
    
    Are there any already known bad chars? y/n
    > n

    Please replace your shellcode with the following, and then binary copy and paste the result here

    \x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f\x20\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2a\x2b\x2c\x2d\x2e\x2f\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x3a\x3b\x3c\x3d\x3e\x3f\x40\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4a\x4b\x4c\x4d\x4e\x4f\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5a\x5b\x5c\x5d\x5e\x5f\x60\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6a\x6b\x6c\x6d\x6e\x6f\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7a\x7b\x7c\x7d\x7e\x7f\x80\x81\x82\x83\x84\x85\x86\x87\x88\x89\x8a\x8b\x8c\x8d\x8e\x8f\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9a\x9b\x9c\x9d\x9e\x9f\xa0\xa1\xa2\xa3\xa4\xa5\xa6\xa7\xa8\xa9\xaa\xab\xac\xad\xae\xaf\xb0\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9\xba\xbb\xbc\xbd\xbe\xbf\xc0\xc1\xc2\xc3\xc4\xc5\xc6\xc7\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf\xd0\xd1\xd2\xd3\xd4\xd5\xd6\xd7\xd8\xd9\xda\xdb\xdc\xdd\xde\xdf\xe0\xe1\xe2\xe3\xe4\xe5\xe6\xe7\xe8\xe9\xea\xeb\xec\xed\xee\xef\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff

    > 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f606162636465666768696a6b6c6d6e6f707172737475767778797a7b7c7d7e7f808182838485868788898a8b8c8d8e8f909192939495969798999a9b9c9d9e9fa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2b3b4b5b6b7b8b9babbbcbdbebfc0c1c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d2d3d4d5d6d7d8d9dadbdcdddedfe0e1e2e3e4e5e6e7e8e9eaebecedeeeff0f1f2f3f4f5f6f7f8f9fafbfcfdfe  
    
    found new bad char \xff
    Bad chars so found so far:
    \xff
    
    -----------------------------------
    
    Allowed chars are: 
    
    \x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f\x20\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2a\x2b\x2c\x2d\x2e\x2f\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x3a\x3b\x3c\x3d\x3e\x3f\x40\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4a\x4b\x4c\x4d\x4e\x4f\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5a\x5b\x5c\x5d\x5e\x5f\x60\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6a\x6b\x6c\x6d\x6e\x6f\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7a\x7b\x7c\x7d\x7e\x7f\x80\x81\x82\x83\x84\x85\x86\x87\x88\x89\x8a\x8b\x8c\x8d\x8e\x8f\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9a\x9b\x9c\x9d\x9e\x9f\xa0\xa1\xa2\xa3\xa4\xa5\xa6\xa7\xa8\xa9\xaa\xab\xac\xad\xae\xaf\xb0\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9\xba\xbb\xbc\xbd\xbe\xbf\xc0\xc1\xc2\xc3\xc4\xc5\xc6\xc7\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf\xd0\xd1\xd2\xd3\xd4\xd5\xd6\xd7\xd8\xd9\xda\xdb\xdc\xdd\xde\xdf\xe0\xe1\xe2\xe3\xe4\xe5\xe6\xe7\xe8\xe9\xea\xeb\xec\xed\xee\xef\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa\xfb\xfc\xfd\xfe


    Bad chars are: 

    \xff


## MagicCalc

This script (./magic_calc.rb) is designed to help with the calculations required to push encoded shellcode to the stack when dealing with an extremely limited allowed character set. It assumes you know that what we're doing here is using a register (after it's been XORd to zero) to calculate the difference between the hex representation of zero to our desired hex code, so that it can be pushed to the stack and executed. If I haven't articulated this well enough, or you haven't come across this yet, do some googling for "manually encoding shellcode to bypass character filters".


    $ ./magic_calc.rb -t 745a053c -s 729735
    _  _ ____ ____ _ ____ ____ ____ _    ____
    |\/| |__| | __ | |    |    |__| |    |   
    |  | |  | |__] | |___ |___ |  | |___ |___
    
                                  by T.J Acton
    
    TARGET: 745a053c
    SEED: 729735
    Finding all 3 subtractions to produce 0x745a053c, from 0x8ba5fac4
    =======================
    #   0xffffffff - 0x745a053c = 0x8ba5fac4                                 
    #
    #   A: 0x7e377b26  + B: 0x1131635    + C: 0xc5b6969      =  0x8ba5fac4     ( Used Seed 729735)
    =======================


## HexSum

This script (./hexsum.rb) is sort of a sanity check for magic_calc.rb. It confirms the calculations are correct, and then provides the hexcodes in little endian format.

    $ ./hexsum.rb 7e377b26 01131635 0c5b6969  reverse
    _  _ ____ _  _ ____ _  _ _  _
    |__| |___  //  [__  |  | |//|
    |  | |___ _//_ ___] |__| |  |
    
                     by T.J Acton
    
    Hexcode: 7e377b26   ||   Final Hexcode: 267b377e
    Hexcode: 01131635   ||   Final Hexcode: 35161301
    Hexcode: 0c5b6969   ||   Final Hexcode: 69695b0c
    
     RESULT: 0xc4faa58b



    $ ./hexsum.rb 7e377b26 01131635 0c5b6969 
    _  _ ____ _  _ ____ _  _ _  _
    |__| |___  //  [__  |  | |//|
    |  | |___ _//_ ___] |__| |  |
    
                     by T.J Acton
    
    
     RESULT: 0x8ba5fac4

## Others... on the way...

