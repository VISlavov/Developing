require 'securerandom'

class Generator
	def initialize level, path
		@@level = level
		@@orig = generate_hex(4).to_s(16).upcase()
		@@orig = ensure_length @@orig, 4 * @@level
		@@orig = prepend_hex_id @@orig, 4
		@@insert = generate_hex(4).to_s(16).upcase()
		@@insert = ensure_length @@insert, 4 * @@level
		@@insert = prepend_hex_id @@insert, 4
		@@organizer = Organizer.new
		@@c_parser = C_parser.new
		@@path = path
		
		@@stable_dec1 = generate_dec(2)
		@@stable_dec2 = generate_dec(2)
			
		@@organizer.mkdir @@path, "exam_files"
		@@organizer.mkdir @@path + "exam_files", "/html"
		@@organizer.mkdir @@path + "exam_files", "/pdf"
		@@organizer.mkdir @@path + "exam_files", "/c"
	end

	def generate_type1
		program_body = []
		
		program_body << 'int orig = ' + @@orig
		program_body << 'int insert = ' + @@insert
		program_body << 'int a = orig | (insert << ' + generate_dec(@@level) + ')'
		program_body << 'printf("%d", a)'
		
		program_body
	end
	
	def generate_type2 
		program_body = generate_type1()
		program_body = append_to_array_end program_body, ['int b = orig | (insert << ' + generate_dec(1) + ')',
															'int AND = a & b'], 'printf("%d", AND)'
	end
	
	def generate_type3 
		program_body = generate_type1()
		program_body = remove_array_part program_body, [program_body.length - 2]
		program_body = append_to_array_end program_body, ['int a = orig | (insert << ' + @@stable_dec1 + ')',
															'int b = orig | (insert << ' + @@stable_dec2 + ')',
															'int OR = a | b'], 'printf("%d", OR)'
	end
	
	def generate_type4 
		program_body = generate_type3()
		program_body = remove_array_part program_body, [program_body.length - 2]
		program_body = append_to_array_end program_body, ['int XOR = a ^ b'], 'printf("%d", XOR)'
	end
	
	def generate_type5 
		program_body = []
		program_body << 'int i = ' + @@orig
		program_body << 'int left = ' + @@orig + ' | (1 << ' + generate_dec(2) + ')'
		program_body << 'printf("%d", left)'
	end
	
	def generate_type6
		rand = ensure_length(generate_hex(8).to_s(16).upcase, 4 * @@level)
		rand = prepend_hex_id(rand, 8)
		
		rand2 = ensure_length(generate_hex(8).to_s(16).upcase, 4 * @@level)
		rand2 = prepend_hex_id(rand2, 8)
		
		program_body = []
		program_body << 'long value1 = ' + rand
		program_body << 'long value2 = ' + rand2
		program_body << 'int result = (value1 << ' + generate_dec(2)  + ') ^ (value2 >> ' + generate_dec(@@level) + ')'
		program_body << 'printf("%d", result)'
	end
	
	def generate_type7
		rand = ensure_length(generate_hex(8).to_s(16).upcase, 4 * @@level)
		
		rand = prepend_hex_id(rand, 8)
		
		program_body = []
		program_body << 'long testValue = ' + rand
		program_body << 'int a = 0'
		program_body << 'if (testValue & (1 << ' + generate_dec(@@level) + '))'
		program_body << '{'
		program_body << '	a = 1'
		program_body << '}'
		program_body << 'else'
		program_body << '{'
		program_body << '	a = 2'
		program_body << '}'
		program_body << 'printf("%d", a)'
	end
	
	def generate_type8
	
	end
	
	def generate_type9
	
	end
	
	def generate_all
		@@c_parser.fill_file generate_type1, @@path + "exam_files/c/1.c"
		@@c_parser.fill_file generate_type1, @@path + "exam_files/c/2.c"
		@@c_parser.fill_file generate_type2, @@path + "exam_files/c/3.c"
		@@c_parser.fill_file generate_type3, @@path + "exam_files/c/4.c"
		@@c_parser.fill_file generate_type4, @@path + "exam_files/c/5.c"
		@@c_parser.fill_file generate_type5, @@path + "exam_files/c/6.c"
		@@c_parser.fill_file generate_type6, @@path + "exam_files/c/7.c"
		@@c_parser.fill_file generate_type7, @@path + "exam_files/c/8.c"
	end
	
	def generate_hex length
		rand = 0
		if length == 4
			nullifier = '0f0f'
		else
			nullifier = 'ff00'
		end
		
		if @@level == 1
			while (rand = SecureRandom.hex(2).hex & nullifier.hex) == 0
			end
		else
			while (rand = SecureRandom.hex(length/2).hex) == 0
			end
		end
		
		rand
	end
	
	def ensure_length string, length
		while string.length < length
			string.insert 0, "0"
		end
		
		string
	end
	
	def generate_dec level
		rand = 0
		if level == 1
			rand = [2, 4, 8, 16].sample
		else
			while (rand = SecureRandom.random_number(18)) % 2 == 0 || rand == 1
			end
		end
		
		rand.to_s
	end
	
	def append_to_array_end str, info, new_end
		if new_end == 0
			array_end = str[str.length - 1]
		else
			array_end = new_end
		end
			
		str.delete_at(str.length - 1)
		info.each do |info_row|
			str << info_row
		end
		
		str << array_end
	end
	
	def remove_array_part array, indexes
		indexes.each do |index|
			array.delete_at(index);
		end
		
		array
	end
	
	def prepend_hex_id string, length
		if @@level == 1 && length == 8
			string = string + string
		end
		
		string.insert 0, "x"
		string.insert 0, "0"
	end
end
