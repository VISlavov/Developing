class Resource

	@@CONTENT_TYPES = {
		:html => "text/html",
		:plain => "text/plain",
		:css => "text/css",  
		:jpeg => "image/jpeg",
		:js => "text/javascript",
	}

	@@SCRIPT_CONTENT_TYPES = {
		:ruby => 'text/ruby',
	}
	
	def initialize request
		@resource = extract_resource(request)
	end
	
	def get_extended_path resource = @resource
		extended_path = '.' + resource

		extended_path
	end
	
	def is_existing
		resource = get_extended_path @resource
		is_existing = File.exists?(resource)

		is_existing
	end

	def is_directory
		resource = get_extended_path @resource
		is_directory = File.directory?(resource)

		is_directory
	end

	def is_empty
		is_empty = (@resource == '')

		is_empty
	end
	
	def get_content_type path = @resource
		ext = File.extname(path)

		return @@CONTENT_TYPES[:html]  if ext == ".html" or ext == ".htm"
		return @@CONTENT_TYPES[:plain] if ext == ".txt"
		return @@CONTENT_TYPES[:css]   if ext == ".css"
		return @@CONTENT_TYPES[:jpeg] if ext == ".jpeg" or ext == ".jpg"
		return @@SCRIPT_CONTENT_TYPES[:ruby] if ext == ".rb"
		return @@CONTENT_TYPES[:html]
	end

	def is_script content_type = get_content_type(@resource)
		is_script = @@SCRIPT_CONTENT_TYPES.has_value? content_type

		is_script
	end

	def extract_resource request
		resource = request.split(' ')[1]

		resource
	end

	def self.CONTENT_TYPES
		@@CONTENT_TYPES
	end

	def self.SCRIPT_CONTENT_TYPES
		@@SCRIPT_CONTENT_TYPES
	end

end
