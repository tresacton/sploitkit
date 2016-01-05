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

## Others... on the way...

