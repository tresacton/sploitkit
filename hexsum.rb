#!/usr/bin/ruby


puts "_  _ ____ _  _ ____ _  _ _  _"
puts "|__| |___  \//  [__  |  | |\//|"
puts "|  | |___ _//\_ ___] |__| |  |"
puts
puts "                 by T.J Acton"
puts                            



# THIS CLASS TURNS STRING OBJECTS INTO HEX FIXNUMS
require 'delegate'
require 'set'





class HexDo < DelegateClass(Fixnum)

def initialize(params)
super
end

def to_s
sign = self < 0 ? "-" : ""
hex = abs.to_s(16)
"#{sign}0x#{hex}"
end

def inspect
to_s
end

def has_bad_chars?
	# this is the list of allowed chars
	# modify this to include more chars if your character set is 
	#        not as restricetd as this.
	nice_list = %w{0x0 01 02 03 04 05 06 07 08 09 0b 0c 0e 0f 10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 25 26 27 28 29 2a 2b 2c 2d 2e 30 31 32 33 34 35 36 37 38 39 3b 3c 3d 3e 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f 50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 60 61 62 63 64 65 66 67 68 69 6a 6b 6c 6d 6e 6f 70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f}
	


	hexdo_tc = to_s
	hexdo_tc = hexdo_tc.gsub("0x","")
	if hexdo_tc.size > 5
		until hexdo_tc.size == 8
			hexdo_tc = '0'<<hexdo_tc
		end
	end
	hexdo_tc = hexdo_tc.scan(/../)

	
	
	hexdo_tc
	nice_set = Set.new nice_list

	result = false

	hexdo_tc.each { |a| !nice_list.include?(a) ? (result = true) : nil}

	result
end

def has_no_bad_chars?
	has_bad_chars? == false
end
end

zero = 0xFFFFFFFF

z = HexDo.new(zero)


# 2.1.1 :396 > wh=HexDo.new(want.to_i(16))
#  => 0xafea75af 
# 2.1.1 :397 > zh=HexDo.new(zero.to_i(16))
#  => 0xffffffff 

# 2.1.1 :398 > "0x%X" % (0xFFFFFFFF - 0xAFEA75AF) 
#  => "0x50158A50" 
# 2.1.1 :399 > "0x%X" % (zh - wh) 
#  => "0x50158A50" 



a =ARGV[0] # => val_1
b =ARGV[1] # => val_2
c =ARGV[2] # => val_2
reverse =ARGV[3] # => val_2

if reverse != 'reverse'
	reverse = false
elsif reverse == 'reverse'	
	reverse = true
end

def little_endian_format hexcode
	final_hexcode = ""
	hexcode_unf = hexcode.to_s
	hexcode_unf = hexcode_unf.gsub("0x","")
	if hexcode_unf.size > 5
		until hexcode_unf.size == 8
			hexcode_unf = '0'+hexcode_unf 
		end
	end
	hexcode_unf = hexcode_unf.scan(/../)
	hexcode = []
	hexcode_unf.each do |b1|
		hexcode << b1.gsub('0x','')
	end
	hexcode.reverse.each do | b|
		final_hexcode += b
	end
	puts "Hexcode: #{hexcode.join}   ||   Final Hexcode: #{final_hexcode}"
	final_hexcode
end

def calculate a,b,c,reverse

	if reverse == true
		a= little_endian_format a
		b= little_endian_format b
		c= little_endian_format c
	end

	a= HexDo.new(a.to_i(16))
	b= HexDo.new(b.to_i(16))
	c= HexDo.new(c.to_i(16))

	result = HexDo.new(a+b+c)


	puts  "\n RESULT: #{result.to_s}\n\n"

end

calculate a,b,c,reverse



















