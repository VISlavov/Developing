require 'fileutils'

class Organizer
	def mkdir path, name
		if(!File.directory?(path + name))
			`mkdir #{path}#{name}`
		end
	end
	
	def rm file
		if(File.exist?(file))
			File.delete(file)
		end
	end
	
	def rm_dir path
		FileUtils.rm_rf(path)
	end

end
