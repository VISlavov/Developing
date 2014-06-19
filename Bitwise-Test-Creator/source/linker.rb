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


generator = Generator.new(level, path)
generator.generate_all()
#generator.generate_type2()




