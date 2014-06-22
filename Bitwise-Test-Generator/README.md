Requirements:
	- ruby version 2.1.0
	- rubygems
	- gem pdfkit
	- gem wkhtmltopdf
	
	Maybe you can run it with older version of ruby if you have:
	- library 'fileutils'
	- library 'securerandom'

Template:
	cd source
	ruby linker.rb [number of tests here] [difficulty: 1 or 2] [path to directory where you want the files]

Example:


	ruby linker.rb 27 1 "./"
	ruby linker.rb 5 2 "../"
