require './c-parser.rb'
require './html-parser.rb'
require './pdf-parser.rb'
require './c-runner.rb'
require './generator.rb'
require './organizer.rb'

def ensure_correct_path path
	if path[path.length - 1] != '/'
		path += '/'
	end
	
	path
end

count = ARGV[0].to_i
level = ARGV[1].to_i
path = ensure_correct_path ARGV[2]

organizer = Organizer.new
c_parser = C_parser.new(organizer)
pdf_parser = Pdf_parser.new()

puts 'The program will be processing your request for a while, please wait...'

organizer.rm_dir(path + "tests")
organizer.mkdir path, "tests"

organizer.setup_base_folders path += "tests/", count

generator = Generator.new(level, path, c_parser, pdf_parser)
html_parser = Html_parser.new(organizer, generator)

generator.generate_all count, html_parser

runner = C_runner.new(path, count, generator, html_parser, organizer, pdf_parser)
runner.create_makefile_and_compile()
