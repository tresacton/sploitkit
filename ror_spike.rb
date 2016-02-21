#!/usr/bin/ruby
require 'pty'
require 'time'

puts "+-+-+-+ +-+-+-+-+-+"
puts "|R|o|R| |S|p|i|k|e|"
puts "+-+-+-+ +-+-+-+-+-+"
puts "      by T.J Acton"
puts ""

if ARGV.count < 3
  puts "Usage: #{__FILE__} ALL 192.168.1.1 8080"
  puts "Three arguments are required - command (e.g. TRUN, or ALL), host, port"
  puts "You'll need to edit this script to change the commands available if you're not exploiting vulnserver (line: 25)"
  exit(2)
end



puts "Running: #{ARGV[0]}"

if ARGV[0].downcase != 'all'
	 commands = ["#{ARGV[0]}"] 
else
	commands = %w{HELP STATS RTIME LTIME SRUN RUN GMON GDOG KSTET GTER HTER LTER KSTAN}
end

host = ARGV[1]
port = ARGV[2]

log=File.open("ror_spike_notes.txt", "a")
log << "-----------------------------------------------\n"
log << "Started script: "
log << Time.now.to_i
log << "\n"
log.close

current_spk_var = ""

commands.each do |command|
	output = File.open( "ror_#{command}.spk","w" )
	output << "printf(\"ror_#{command}.spk : \"); //print to terminal command and filename\n"
	output << "s_readline(); //print received line from server\n"
	output << "s_string(\"#{command} \"); // send \"#{command} \" to program\n"
	output << "s_string_variable(\"COMMAND\"); //send fuzzed string\n"
	output << "s_readline();\n"
	output.close

	begin
  		PTY.spawn( "generic_send_tcp #{host} #{port} ror_#{command}.spk 0 0" ) do |stdout, stdin, pid|
	    		begin
      				stdout.each do |line|
					print "cmd: #{command} - " 
					print "SPK: #{line}" 
					puts "closed socked" if line.include? "closed socket"
                                        puts "doing next command" if line.include? "2043"
 					if line.include? "Fuzzing Variable"
						current_spk_var = line
					end
					if line.include? "closed socket"
						log=File.open("ror_spike_notes.txt", "a")
						log << current_spk_var
						log << line
						print "Enter Crash Condition Notes: "
						notes = STDIN.gets.chomp 
						log << "NOTES: #{notes}"
						log << "\n"
						log << "[*] Reproduce with: generic_send_tcp #{host} #{port} ror_#{command}.spk 0 #{current_spk_var.split(':')[1]}\n\n"
						log.close
						puts "[*] Reproduce with: generic_send_tcp #{host} #{port} ror_#{command}.spk 0 #{current_spk_var.split(':')[1]}\n\n The crash condition has been logged at: ./ror_spike_notes.txt \n\n "
						abort("-- Terminated. Enjoy getting your shell. --")
					end
					next
    				end
			rescue Errno::EIO
    			end
  		end
  		puts "The child process exited!"
	end
        puts " |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
        puts "                              doing next command" 
        puts " |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
	next
end
