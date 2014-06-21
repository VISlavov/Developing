class C_runner

	def initialize path, count, generator, html_parser, organizer
		@@count = count
		@@path = path
		@@generator = generator
		@@organizer = organizer
		@@html_parser = html_parser
		@@html_parser.add_style_target("answers")
	end
	
	def create_makefile_and_compile
		i = 0
		results = []
		current = ""
		
		while i < @@count
			path = @@path + i.to_s + "/questions/c/"
			
			@@organizer.cp '../templates/Makefile', path
			
			`make -C #{path}`
			
			for i1 in 1..12
				results << `./#{path}#{i1}`
			end
			
			send_to_html results, @@path, i.to_s
			
			results.clear
			i = i + 1
		end
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
	
	def send_to_html results, path, number
		html_body = []
		bin = ""
		hex = ""
		path += number + "/answers/html/answers.html"
		i = 1
		
		html_body << @@html_parser.create_tag('Answers for test ' + number, 'h1')
		
		results.each do |str|
			bin = transform str, 2
			hex = transform str, 16
			
			html_body << @@html_parser.create_tag('Question ' + i.to_s, 'h2')
			
			html_body << @@html_parser.create_tag('Answer as decimal:', 'h4')
			html_body << @@html_parser.create_tag(str)
			
			html_body << @@html_parser.create_tag('Answer as binary:', 'h4')
			html_body << @@html_parser.create_tag(bin)
			
			html_body << @@html_parser.create_tag('Answer as hex:', 'h4')
			html_body << @@html_parser.create_tag(hex)
			i = i + 1
		end
		
		
		@@html_parser.fill_file html_body, path
	end
end
