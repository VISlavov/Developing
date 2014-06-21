class Html_parser
	
	def initialize organizer
		@@organizer = organizer
		@@header = ["<DOCTYPE! html>", "<html>", "<body>"]
		@@tail = ["</body>", "</html>"]
	end
	
	def write_separated_rows info, file
		info.each do |row|
			file.puts row + "\n"
		end
	end
	
	def create_div info
		info.insert 0, '<div>'
		info.insert info.length, '</div>'
		
		info
	end

	def fill_file info, file
		@@organizer.rm file
		
		File.open(file, "a+") do |f|
			write_separated_rows @@header, f
			write_separated_rows info, f
			write_separated_rows @@tail, f
		end
	end
	
	def add_style_target target, swap = false
		if swap == true
			@@header.delete_at(@@header.length - 1)
		end
			
		if target == "answers"
			@@header << "<style type='text/css' src='answers.css'> </style>"
		else
			@@header << "<style type='text/css' src='questions.css'> </style>"
		end
	end
	
end
