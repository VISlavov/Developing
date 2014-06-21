class C_runner

	def initialize path, count, generator, html_parser, organizer, pdf_parser
		@@count = count
		@@path = path
		@@generator = generator
		@@organizer = organizer
		@@html_parser = html_parser
		@@html_parser.add_style_target("answers")
		@@pdf_parser = pdf_parser
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
			
			pust full_path = File.join(File.dirname(__FILE__), @@path + i.to_s)
			@@html_parser.create_answer_html results, @@path, i.to_s
			@@pdf_parser.send_html_to_pdf @@path + i.to_s + "/answers/" + "html/answers.html", @@path + i.to_s + "/answers/" + "pdf/answers.pdf"
			
			results.clear
			@@organizer.rm_dir path
			
			i = i + 1
		end
	end
	
end
