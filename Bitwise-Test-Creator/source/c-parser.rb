def write_separated_rows info, file
	info.each do |row|
		file.puts enhanced_writing(row)
	end
end

def enhanced_writing row
	if(row == "}" || row == "{" || row == "#include <stdio.h>" || row == "int main()")
		full_row = row + "\n"
	else
		full_row = row + ";\n"
	end
end

def fill_file info
	header = ["#include <stdio.h>", "int main()", "{"]
	tail = ["return 0", "}"]

	File.open("../templates/template.c", "a+") do |f|
		write_separated_rows header, f
		write_separated_rows info, f
		write_separated_rows tail, f
	end
end
