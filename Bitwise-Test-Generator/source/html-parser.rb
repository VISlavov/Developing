class Html_parser
	
	def initialize organizer, generator
		@@organizer = organizer
		@@generator = generator
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
	
	def add_style target, swap = false
		if swap == true
			@@header.delete_at(@@header.length - 1)
		end
			
		if target == 'answers'
			@@header << create_tag(File.read("../templates/answers.css"), 'style')
		else
			@@header << create_tag(File.read("../templates/questions.css"), 'style')
		end
	end
	
	def create_question_html info, path, number
		html_body = []
		bin = ""
		hex = ""
		path += number + "/questions/html/questions.html"
		i = 1
		
		html_body << create_tag('Answers for test ' + number, 'h1')
		
		results.each do |str|
			bin = transform str, 2
			hex = transform str, 16
			
			html_body << create_tag('Question ' + i.to_s, 'h2')
			
			html_body << create_tag('Answer as decimal:', 'h4')
			html_body << create_tag(str)
			
			html_body << create_tag('Answer as binary:', 'h4')
			html_body << create_tag(bin)
			
			html_body << create_tag('Answer as hex:', 'h4')
			html_body << create_tag(hex)
			i = i + 1
		end
		
		fill_file html_body, path
	end
	
	def create_answer_html results, path, number
		html_body = []
		bin = ""
		hex = ""
		path += number + "/answers/html/answers.html"
		i = 1
		
		html_body << create_tag('Answers for test ' + number, 'h1')
		
		results.each do |str|
			bin = transform str, 2
			hex = transform str, 16
			
			html_body << create_tag('Question ' + i.to_s, 'h2')
			
			html_body << create_tag('Answer as decimal:', 'h4')
			html_body << create_tag(str)
			
			html_body << create_tag('Answer as binary:', 'h4')
			html_body << create_tag(bin)
			
			html_body << create_tag('Answer as hex:', 'h4')
			html_body << create_tag(hex)
			i = i + 1
		end
		
		fill_file html_body, path
	end
	
	def transform string, type
		many = []
		
		if string.include? '['
			many = string.gsub(/[^A-Za-z0-9-]/, " ").strip.split(' ')
		else
			many << string
		end
		
		case type
			when 2
				for i1 in 0..many.length - 1
					many[i1] = many[i1].to_i
					many[i1] = many[i1].to_s(2)
				end
			when 16
				for i1 in 0..many.length - 1
					many[i1] = many[i1].to_i
					many[i1] = @@generator.prepend_hex_id(many[i1].to_s(16))
				end
			else
				nil
		end
		
		many.to_s.gsub(/[^A-Za-z0-9-]/, " ").strip.gsub("    ", "; ");
	end
	
end
