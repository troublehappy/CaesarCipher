
class Caesar
	def initialize(shift)
		alphabet_lower = 'abcdefghijklmnopqrstuvwxyz'
		alphabet_upper = alphabet_lower.upcase
		alphabet = alphabet_lower + alphabet_upper
		index = shift % alphabet.size
		encrypted_alphabet = alphabet[index..-1] + alphabet[0..index]
		setup_lookup_tables(alphabet, encrypted_alphabet)
	end

	def setup_lookup_tables (decrypted_alphabet, encrypted_alphabet)
		@encryption_hash = {}
		@decryption_hash = {}

		0.upto(decrypted_alphabet.size) do |index|
			@encryption_hash[decrypted_alphabet[index]] = encrypted_alphabet[index]
			@decryption_hash[encrypted_alphabet[index]] = decrypted_alphabet[index]
		end
	end

	def encrypt(string)
		result = []
		string.each_char do |c|
			if @encryption_hash[c]
				result << @encryption_hash[c]
			else
				result << c
			end
		end
		result.join
	end


	def decrypt(string)
		result = []
		string.each_char do |c|

			if @decryption_hash[c]
				result << @decryption_hash[c]
			else
				result << c
			end

		end

		result.join
	end
end

class CodeBreaker
	COMMANDS = ['e', 'd']
	def intialize
		@input_file = ''
		@output_file = ''
		@password = ''
	end

	def get_command
		print "Do you want to (e)ncrypt or (d)ecrypt a file "
		@command = gets.chomp.downcase
		#read user's command, removes tailing, letter should be lowercase
		if !COMMANDS.include?(@command)
			puts "Unknow command. It should be 'e' or 'd' "
			return false
		end
		true
	end

	def get_input_file
		print "Enter the name of input file: "
		@input_file = gets.chomp
		#Check if the file exists
		if !File.exists?(@input_file)
			puts "Cannot find the input file"
			return false
		end
		true
	end

	def get_output_file
		print "Enter the name of output file: "
		@output_file = gets.chomp
		if File.exists?(@output_file)
			puts "The output file already exists"
			return false
		end
		true
	end

	def get_secret
		print "Enter the secret password: "
		@password = gets.chomp
	end
	
	def convert(encoder,string)
		if @command == 'e'
			encoder.encrypt(string)
		else
			enconder.decrypt(string)
		end
	end
	
	def process_files
		encoder = Caesar.new(@password.size)
		#write into output file
		File.open(@output_file, "w") do |output|
			IO.foreach(@input_file) do |line|
				converted_line = convert(encoder,line)
				output.puts converted_line
			end
		end
	end

	def run
		if get_command && get_input_file && get_output_file && get_secret
			process_files
			true
		end
	end
end 

puts "Code Breaker will encrypt or decrypt a file of your choice"
puts ""

#Create an instance of main class
codebreaker = CodeBreaker.new
if codebreaker.run
	puts "All good!"
else 
	puts "Didn't work"
end