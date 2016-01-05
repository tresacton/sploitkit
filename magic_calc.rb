#!/usr/bin/ruby


# THIS CLASS TURNS STRING OBJECTS INTO HEX FIXNUMS
require 'delegate'
require 'set'

require 'optparse'

ARGV << '-h' if ARGV.count < 1


options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ./magic_calc.rb -t=0x1800188b, -s 1919813  # -s is optional"

  opts.on('-t', '--target=0x1800188b', 'The target calculation to arrive at') { |v| options[:target] = v }
  opts.on('-s', '--seed=1919813', 'Seed number. Can be left blank. Otherwise, include it to arrive at the same result as last time') { |v| options[:seed] = v }
  opts.on('-v', '--verbose=true', 'Print all iterations') do |v| 
  	if v == 'true' 
  		options[:verbose] = true  
  	else
  		options[:verbose] = false
  	end
  end


  opts.on("-h", "--help", "Prints this help page") do
    puts opts
    exit
  end


end.parse!

verbose = options[:verbose]

target_hex = options[:target]
seed = options[:seed].to_i
if seed == 0
        seed = rand(1999999)
end



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


#
#
#
# SCRIPT B STARTING
#
#
verbose = options[:verbose]


target_hex = options[:target]
seed = options[:seed].to_i
if seed == 0
        seed = rand(1999999)
end

puts "TARGET: #{target_hex}"
puts "SEED: #{seed}"

def find_the_magic_calculations(target_hex2, seed, verbose)
	# puts "#    Seed #{seed}"
	# script.rb
	# bad_chars =  ARGV[0] # => NOT YET IMPLEMENTED AS ARGUMENT
	zero = 0xFFFFFFFF

	z = HexDo.new(zero)


	target_hex = HexDo.new target_hex2 .to_i(16)
	goal_total = z-target_hex+1
	goal_total = HexDo.new(goal_total)


	puts "Finding all 3 subtractions to produce #{target_hex}, from #{goal_total}"

	zero = 0xFFFFFFFF
	zero = HexDo.new(zero.to_s(16).to_i(16))

	# goal_total = HexDo.new(goal_total.to_i(16))

	# a = HexDo.new(goal_total/2)
	a = HexDo.new(goal_total - 3)



	# Goal total is a HexDo Object, need to add no_bad_chars? method
	if HexDo.new(((a.to_s.gsub("0x","").scan(/../).to_a[1])).to_i(16)).has_bad_chars?
		aa=a.to_s.gsub("0x","").scan(/../).to_a
		aa[1].gsub("00","99")
		a=HexDo.new(aa.join.to_i(16))
	end



	until a.has_no_bad_chars?
		a = HexDo.new(a - seed - 10001000)
		puts a if verbose == true
		a
	end

	b = HexDo.new(a - 1)

	b = HexDo.new(0x00 + seed + 10001000)
	until b.has_no_bad_chars?
		b = HexDo.new(b + seed)
		puts b if verbose == true
	end

	# c = HexDo.new(((b/10)*9.5).to_i)
	# c = HexDo.new(0x00 + 1)

	c=HexDo.new(goal_total-a-b)
	if c.has_bad_chars? 
		puts "C has bad chars: #{c}"

	else
		puts "======================="
		puts "#   #{z} - #{target_hex} = #{goal_total}                                 "        
		puts "#"
		puts "#   A: #{a}  + B: #{b}    + C: #{c}      =  #{HexDo.new(a+b+c)}     ( Used Seed #{seed})"
		puts "======================="
		exit
	end
	[a,b,c]

end


def all_good? a,b,c
	result = nil
	if c.has_bad_chars? 
		result = false 
		# puts result.to_s + 2.to_s
	elsif a.to_s.size < 9
		result = false 
		# puts result.to_s + 3.to_s
	elsif b.to_s.size < 9
		result = false 
		# puts result.to_s + 4.to_s
	elsif c.to_s.size < 9
		result = false 
		# puts result.to_s + 5.to_s
	else
		result = true
		# puts result.to_s + 6.to_s
	end
	result
end

#find_the_magic_calculations("",0x1800188B,1111331)
results = find_the_magic_calculations(target_hex,seed, verbose)

a = results[0]
b = results[1]
c  = results[2]

(1..50).each do |n|
	until all_good?(a,b,c) == true
		random_seed = rand(1999999)
		find_the_magic_calculations(target_hex,random_seed, verbose) if c.has_bad_chars?
	end
end



