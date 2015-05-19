require './resource.rb'

class Request

	attr_accessor :resource, :body

	def initialize session
		@REQUEST_TYPES = {
			:get => 'GET',
			:post => 'POST',
		}

		@session = session
		@request = ''
		set_request session
		
		@headers = get_headers()
		@body = get_body()

		@resource = Resource.new(@request)
	end
	
	def get_request_method
		method = @request.split(" ")[0]
		
		method	
	end	

	def is_get
		method = get_request_method
		
		if method == @REQUEST_TYPES[:get]
			is_get = true
		else
			is_get = false
		end	
		
		is_get
	end

	def get_headers
		headers = {}

		#get the first heading (first line)
		headers['Heading'] = @session.gets.gsub /^"|"$/, ''.chomp
		method = headers['Heading'].split(' ')[0]

		#parse the header
		while true
			#do inspect to get the escape characters as literals
			#also remove quotes
			line = @session.gets.inspect.gsub /^"|"$/, ''

			#if the line only contains a newline, then the body is about to start
			break if line.eql? '\r\n'

			label = line[0..line.index(':')-1]

			#get rid of the escape characters
			val = line[line.index(':')+1..line.length].tap{|val|val.slice!('\r\n')}.strip
			headers[label] = val
		end 

		headers
	end

	def get_body
		content_length = @headers['Content-Length'].to_i
		body = @session.read(content_length) 

		body
	end

	def set_request session
		@request = session.gets
		
		puts @request
	end

	def set_session session
		@session = session
	end

end
