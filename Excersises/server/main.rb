require './server.rb'

port = ARGV[0]
server = Server.new

server.start port
