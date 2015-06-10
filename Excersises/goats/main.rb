require './arguments.rb'
require './util.rb'

arguments = Arguments.new()
arguments.get_arguments()
arguments.check_arguments()

capacity = find_needed_capacity(arguments)

puts capacity
