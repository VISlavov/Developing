class C_runner

	def initialize path, count, generator, html_parser, organizer
		@@count = count
		@@path = path
		@@generator = generator
		@@organizer = organizer
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
			
			puts "------------"
			send_to_html results
			puts "------------"
			
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
					many[i1] = @@generator.prepend_hex_id(many[i1].to_s(16));
				end
			else
				nil
		end
		
		many.to_s.gsub(/[^A-Za-z0-9-]/, "    ").strip
	end
	
	def send_to_html results
		results.each do |str|
			p str
		end
		puts ""
		results.each do |str|
			p transform str, 2
		end
		puts ""
		results.each do |str|
			p transform str, 16
		end
	end
end
