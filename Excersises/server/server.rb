require './multiclienttcpserver.rb'
require './request.rb'

class Server
	
	@@STATUS_CODES = {
		:success => 200,
		:not_found => 404,
		:bad_request => 400,
	}

	def initialize
	end

	def bad_request400 session
		session.print "HTTP/1.1 #{@@STATUS_CODES[:bad_request]}/ Bad Request\r\nServer Vicky\r\n\r\n"
		session.print "#{@@STATUS_CODES[:bad_request]} - Bad Request."
	end

	def not_found404 session
		session.print "HTTP/1.1 #{@@STATUS_CODES[:not_found]}/ Object Not Found\r\nServer Vicky\r\n\r\n"
		session.print "#{@@STATUS_CODES[:not_found]} - Resource cannot be found."
	end

	def success200 resource, session, is_file
		if is_file
			content_type = resource.get_content_type()
		else
			content_type = Resource.CONTENT_TYPES[:plain]
		end
		
		session.print "HTTP/1.1 #{@@STATUS_CODES[:success]}/OK\r\nServer: Vicky\r\nContent-method: #{content_type}\r\n\r\n"
	end
	
	def send resource, session, is_file
		success200(resource, session, is_file)

		if is_file
			resource_path = resource.get_extended_path()

			File.open(resource_path, "rb") do |f|
				while (!f.eof?) do
					buffer = f.read(256)
					session.write(buffer)
				end
			end
		else
			session.write(resource)
		end
	end

	def receive resource, session, request
		resource_path = resource.get_extended_path

		File.open(resource_path, 'w') do |f|
			f << request.body 
		end

		success200(resource, session, true)
	end

	def handle_execution resource, session, request
		resource_path = resource.get_extended_path()
		method = request.get_request_method() 

		result = `ruby #{resource_path} #{method}`
		send(result, session, false)
	end

	def handle_get resource, session
		send(resource, session, true)
	end

	def handle_post resource, session, request
		receive(resource, session, request)
	end

	def status resource, is_script, is_get
		status_code = @@STATUS_CODES[:success]
		
		if resource.is_empty() 
			status_code = @@STATUS_CODES[:bad_request]
		elsif resource.is_directory()
			status_code =	@@STATUS_CODES[:bad_request]
		else
			if is_script || is_get
				if !resource.is_existing()
					status_code = @@STATUS_CODES[:not_found]
				end
			end
		end

		status_code
	end

	def handle_session session
		request = Request.new(session)
		resource = request.resource
		is_get = request.is_get()
		is_script = resource.is_script()
		status  = status(resource, is_script, is_get)

		case status
			when @@STATUS_CODES[:not_found]
				not_found404(session)
			when @@STATUS_CODES[:bad_request]
				bad_request400(session)
			else
				if is_script 
					handle_execution(resource, session, request)
				else
					if is_get
						handle_get(resource, session)
					else
						handle_post(resource, session, request)
					end
				end
		end

		session.close
	end

	def start port
		webserver = MulticlientTCPServer.new(port, 1, true)
		puts "Server listening on port #{port} ..."
		
		loop do
			if (session = webserver.get_socket)
				handle_session session
			end
		end
	end

	def self.STATUS_CODES
		@@STATUS_CODES
	end

end
