require './resource.rb'
require 'cgi'

class Request

	attr_accessor :resource, :body, :arguments

	@@ARGUMENTS_SEPARATOR = '&'
	@@ARGUMENTS_INDICATOR = '?'

	def initialize session
		@REQUEST_TYPES = {
			:get => 'GET',
			:post => 'POST',
		}

		@arguments = {}
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
		request = session.gets

		if request.include? @@ARGUMENTS_INDICATOR
			request = request.split('?')
			arguments = request[1].split(' ')

			request = "#{request[0]}  #{arguments[1]}"
			arguments = arguments[0]

			set_arguments(arguments)
		end	

		@request = request
		puts @request
	end

	def set_arguments arguments
		if arguments.include? @@ARGUMENTS_SEPARATOR
			arguments = arguments.split(@@ARGUMENTS_SEPARATOR)
		else
			arguments = [arguments]
		end
		
		arguments.each do |arg|
			if arg.eql? 'method'
				arg = "#{arg}=#{get_request_method()}"
			end

			if arg.include? '='
				arg = arg.split('=')

				key = arg[0]
				value = arg[1]

				@arguments[key] = value
			end
		end
	end

	def get_formatted_arguments arguments = @arguments
		formatted_arugments = ''
		
		arguments.each do |arg|
			if formatted_arugments != ''
				formatted_arugments += ' '
			end

			formatted_arugments += CGI::unescape(arg[1]).gsub(' ', '_').gsub('"', '!')
		end

		formatted_arugments
	end

	def set_session session
		@session = session
	end

end
