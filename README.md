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


## BadChars

This script (./badchars.rb) is designed to help determine which chars are bad. This script assumes you are working with Olly (or at least, something that results in hex printed in the same format as Olly's binary paste (e.g. 01 0203 04 05 instead of \x01\x02\x03\x04\x05). Remember, I wrote this to suit me. I'm happy to accept pull requests if anybody would like to contribute to making it a little friendlier for use with other debuggers...


## MagicCalc

This script (./magic_calc.rb) is designed to help with the calculations required to push encoded shellcode to the stack when dealing with an extremely limited allowed character set. It assumes you know that what we're doing here is using a register (after it's been XORd to zero) to calculate the difference between the hex representation of zero to our desired hex code, so that it can be pushed to the stack and executed. If I haven't articulated this well enough, or you haven't come across this yet, do some googling for "manually encoding shellcode to bypass character filters".


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

