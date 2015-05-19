require './server.rb'

port = ARGV[0]
work_mechanism = ARGV[1]
script_timeout = ARGV[2]
server = Server.new(script_timeout)

server.start(port, work_mechanism)
