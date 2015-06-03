require 'timeout'
require 'eventmachine'

require './multiclienttcpserver.rb'
require './request.rb'

class Server
	
	@@SCRIPT_TIMEOUT = 5
	
	@@WORK_MECHANISMS = {
		:threads => 'threads',
		:forking => 'forking',
		:async => 'async',
	}
	
	@@STATUS_CODES = {
		:success => 200,
		:not_found => 404,
		:bad_request => 400,
		:service_unavailable => 503,
	}

	def initialize timeout = @@SCRIPT_TIMEOUT
		@@SCRIPT_TIMEOUT = timeout.to_i
	end

	def bad_request400 session
		message = "HTTP/1.1 #{@@STATUS_CODES[:bad_request]}/ Bad Request\r\nServer Vicky\r\n\r\n"
		print_to_session(session, message)

		message = "#{@@STATUS_CODES[:bad_request]} - Bad Request."
		print_to_session(session, message)
	end

	def not_found404 session
		message = "HTTP/1.1 #{@@STATUS_CODES[:not_found]}/ Object Not Found\r\nServer Vicky\r\n\r\n"
		print_to_session(session, message)

		message = "#{@@STATUS_CODES[:not_found]} - Resource cannot be found."
		print_to_session(session, message)
	end

	def service_unavailable503 session, extra_message = "This service is unavailable right now."
		message = "HTTP/1.1 #{@@STATUS_CODES[:service_unavailable]}/ Service Unavailable\r\nServer Vicky\r\n\r\n"
		print_to_session(session, message)

		message = "#{@@STATUS_CODES[:service_unavailable]} - " + extra_message
		print_to_session(session, message)
	end

	def success200 resource, session, is_file
		if is_file
			content_type = resource.get_content_type()
		else
			content_type = Resource.CONTENT_TYPES[:plain]
		end

		status_code = "HTTP/1.1 #{@@STATUS_CODES[:success]}/OK"
		server = "Server: Vicky"
		content_method = "Content-method: #{content_type}"
		allow_headers = "Access-Control-Allow-Headers: accept, content-type"
		allow_methods = "Access-Control-Allow-Methods: POST, GET"
		allow_origin = "Access-Control-Allow-Origin: *"

		message = "#{status_code}\r\n#{server}\r\n#{content_method}\r\n#{allow_headers}\r\n#{allow_origin}\r\n#{allow_methods}\r\n\r\n"
		print_to_session(session, message)
	end

	def write_to_session session, buffer
		begin
			session.write(buffer)
		rescue Errno::EPIPE
			-1			
		end
	end

	def print_to_session session, data
		begin
			session.print(data)
		rescue Errno::EPIPE
			-1			
		end
	end
	
	def send resource, session, is_file
		success200(resource, session, is_file)

		if is_file
			resource_path = resource.get_extended_path()

			File.open(resource_path, "rb") do |f|
				while (!f.eof?) do
					buffer = f.read(256)
					write_to_session(session, buffer)
				end
			end
		else
			write_to_session(session, resource)
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
		arguments = request.get_formatted_arguments()
		result = ''

		print arguments

		begin
			Timeout::timeout(@@SCRIPT_TIMEOUT) do	
				result = `ruby #{resource_path} #{arguments}`
			end
			
			send(result, session, false)
		rescue Timeout::Error
			message = "Script execution failed to fit in the specified time - #{@@SCRIPT_TIMEOUT} sec."
			service_unavailable503(session, message)
		end
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

	def handle_session_async webserver
		EventMachine.run do
			loop do
				if (session = webserver.get_socket)
					EM.defer do
						handle_session(session)
					end
				end
			end
		end
	end

	def join_finished_threads
		Thread.list.each do |t|
			if(t != Thread.current && t.status == "sleep")
				t.join
			end
		end
	end

	def handle_session_with_threads session
		join_finished_threads()

		Thread.new do
			handle_session(session)
		end
	end

	def handle_session_with_forking session
		pid = Process.fork do
			handle_session(session)
		end

		Process.detach(pid)
		session.close()
	end

	def handle_invalid_work_mechanism work_mechanism
		puts "Invalid work mechanism selected - '#{work_mechanism}'"
		puts "Available work mechanisms: #{@@WORK_MECHANISMS}"
		exit
	end

	def choose_work_mechanism webserver, work_mechanism
		if (session = webserver.get_socket)
			case work_mechanism
				when @@WORK_MECHANISMS[:threads]
					handle_session_with_threads(session)
				when @@WORK_MECHANISMS[:forking]
					handle_session_with_forking(session)
				else
					handle_session(session)
			end
		end
	end

	def start port, work_mechanism
		webserver = MulticlientTCPServer.new(port, 1, true)
		puts "Server listening on port #{port} ..."
		
		if work_mechanism == @@WORK_MECHANISMS[:async]
			handle_session_async(webserver)
		else
			loop do
				choose_work_mechanism(webserver, work_mechanism)
			end
		end
	end

	def self.STATUS_CODES
		@@STATUS_CODES
	end

end
