class Html_parser
	
	def initialize organizer
		@@organizer = organizer
		@@header = ["<DOCTYPE! html>", "<html>", "<body>", "<style type='text/css' src='answers_styles.css'> </style>"]
		@@tail = ["</body>", "</html>"]
	end
	
	def write_separated_rows info, file
		info.each do |row|
			file.puts row + "\n"
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
