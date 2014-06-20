class C_runner

	def initialize path, count
		@@count = count
		@@path = path
	end
	
	def create_makefile
		i = 0
		i1 = 1
		
		while i < @@count
			path = @@path + i.to_s + "/questions/c/"
			
			File.open(path, "a+") do |f|
			while i1 <= 12
				`gcc #{path}#{i1}.c -o #{i1}`
				i1 = i1 + 1
			end
			
			i1 = 1
			i = i + 1
		end
	end
	
end
