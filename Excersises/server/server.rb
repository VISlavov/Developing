require './multiclienttcpserver.rb'

class Server
	
	def initialize
		@REQUEST_TYPES = {
			:get => 'GET',
			:post => 'POST',
		}
	end

	def get_content_type(path)
		  ext = File.extname(path)
		  return "text/html"  if ext == ".html" or ext == ".htm"
		  return "text/plain" if ext == ".txt"
		  return "text/css"   if ext == ".css"
		  return "image/jpeg" if ext == ".jpeg" or ext == ".jpg"
		  return "image/gif"  if ext == ".gif"
		  return "image/bmp"  if ext == ".bmp"
		  return "text/plain" if ext == ".rb"
		  return "text/xml"   if ext == ".xml"
		  return "text/xml"   if ext == ".xsl"
		  return "text/html"
	end
	
	def get_request_method request
		method = request.split(" ")[0]
		
		method	
	end	

	def is_get request
		method = get_request_method request
		
		if method == @REQUEST_TYPES[:get]
			is_get = true
		else
			is_get = false
		end	
		
		is_get
	end

	def get_resource resource, session
		contentType = get_content_type(resource)
		session.print "HTTP/1.1 200/OK\r\nServer: Vicky\r\nContent-method: #{contentType}\r\n\r\n"

		File.open(resource, "rb") do |f|
			while (!f.eof?) do
				buffer = f.read(256)
				session.write(buffer)
			end
		end
	end

	def get_headers session
		headers = {}

		#get the first heading (first line)
		headers['Heading'] = session.gets.gsub /^"|"$/, ''.chomp
		method = headers['Heading'].split(' ')[0]

		#parse the header
		while true
				#do inspect to get the escape characters as literals
				#also remove quotes
				line = session.gets.inspect.gsub /^"|"$/, ''

				#if the line only contains a newline, then the body is about to start
				break if line.eql? '\r\n'

				label = line[0..line.index(':')-1]

				#get rid of the escape characters
				val = line[line.index(':')+1..line.length].tap{|val|val.slice!('\r\n')}.strip
				headers[label] = val
		end 

		headers
	end

	def get_body session, headers
		content_length = headers['Content-Length'].to_i
		body = session.read(content_length) 

		body
	end

	def handle_get request, session
		resource = request.gsub(/GET\ \//, '').gsub(/\ HTTP.*/, '').chomp

		if !File.exists?(resource)
			session.print "HTTP/1.1 404/Object Not Found\r\nServer Vicky\r\n\r\n"
			session.print "404 - Resource cannot be found."
		else
			if !File.directory?(resource)
				get_resource resource, session
			end
		end
	end

	def handle_post request, session
		resource = request.gsub(/POST\ \//, '').gsub(/\ HTTP.*/, '').chomp
		headers = get_headers(session)
		body = get_body(session, headers)
		
		File.open(resource, 'w') do |f|
			f << body 
		end
	end

	def handle_session session
		request = session.gets
		puts request
		
		if is_get(request)
			handle_get request, session
		else
			handle_post request, session		
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

end
