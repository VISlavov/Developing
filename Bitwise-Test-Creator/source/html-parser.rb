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
	
	def create_tag info, tag = 'div'
		info.insert 0, (tag = tag.insert(0, '<')).insert(tag.length, '>')
		info.insert info.length, (tag.insert 1, '/')
		
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
			
		if target == 'answers'
			@@header << '<link rel="stylesheet" type="text/css" href="answers.css">'
		else
			@@header << '<link rel="stylesheet" type="text/css" href="questons.css">'
		end
	end
	
end
