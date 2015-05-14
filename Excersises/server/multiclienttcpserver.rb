require 'socket'

class MulticlientTCPServer

    def initialize( port, timeout, verbose )
        @port = port        # the server listens on this port
        @timeout = timeout  # in seconds
        @verbose = verbose  # a boolean
        @connections = []
        @server = 
            begin
                TCPServer.new( @port )
            rescue SystemCallError => ex
                raise "cannot initialize tcp server for port #{@port}: #{ex}"
            end
    end

    def remove_closed_sockets
			@connections.each do |c|
        begin
					c.eof?
				rescue IOError
					@connections.delete(c)		
				end
			end
    end

    def get_current_connections
			ios = nil

			while !ios
				begin
					ios = select( [@server]+@connections, nil, @connections, @timeout ) or
						return nil
				rescue IOError
					remove_closed_sockets()
				end
			end

			ios
    end

    def get_socket
  			ios = get_current_connections()

				if ios
					# disconnect any clients with errors
					ios[2].each do |sock|
							sock.close
							@connections.delete( sock )
							raise "socket #{sock.peeraddr.join(':')} had error"
					end
					# accept new clients
					ios[0].each do |s| 
							# loop runs over server and connections; here we look for the former
							s==@server or next 
							client = @server.accept or
									raise "server: incoming connection, but no client"
							@connections << client
							@verbose and
									puts "server: incoming connection no. #{@connections.size} from #{client.peeraddr.join(':')}"
							# give the new connection a chance to be immediately served 
							ios = select( @connections, nil, nil, @timeout )
					end
					
					if ios
						# process input from existing client
						ios[0].each do |s|
								# loop runs over server and connections; here we look for the latter
								s==@server and next
								# since s is an element of @connections, it is a client created
								# by @server.accept, hence a TcpSocket < IPSocket < BaseSocket
								if s.eof?
										# client has closed connection
										@verbose and
												puts "server: client closed #{s.peeraddr.join(':')}"
										@connections.delete(s)
										next
								end
								
								return s # message can be read from this
						end
					end
				end	

        return nil # no message arrived
    end

end # class MulticlientTCPServer
