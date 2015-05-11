require './arguments.rb'
require './util.rb'

arguments = Arguments.new
arguments.get_arguments

capacity = find_needed_capacity arguments

puts capacity
