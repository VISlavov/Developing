class C_parser
	
	def initialize organizer
		@@organizer = organizer
		@@header = ["#include <stdio.h>", "int main()", "{"]
		@@tail = ["return 0", "}"]
	end
	
	def write_separated_rows info, file
		info.each do |row|
			file.puts enhanced_writing(row)
		end
	end
	
	def generate_exceptions
		exceptions = []
		
		@@header.each do |elem|
			exceptions << elem
		end
		
		exceptions << @@tail[1]
		exceptions << "else"
		
		exceptions
	end

	def enhanced_writing row
		if generate_exceptions().include? row
			full_row = row + "\n"
		else
			if row =~ /\bif\b/
				full_row = row + "\n"
			else
				full_row = row + ";\n"
			end
		end
	end

	def fill_file info, file
		@@organizer.rm file
		
		File.open(file, "a+") do |f|
			write_separated_rows @@header, f
			write_separated_rows info, f
			write_separated_rows @@tail, f
		end
	end
	
end
