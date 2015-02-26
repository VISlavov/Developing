require 'securerandom'

class Generator

	def initialize level, path, c_parser, pdf_parser
		@@level = level
		@@orig = generate_hex(4).to_s(16).upcase()
		@@orig = ensure_length @@orig, 4
		@@orig = prepend_hex_id @@orig, 4
		@@insert = generate_hex(4).to_s(16).upcase()
		@@insert = ensure_length @@insert, 4
		@@insert = prepend_hex_id @@insert, 4
		
		@@c_parser = c_parser
		@@pdf_parser = pdf_parser
		
		@@path = path
		
		@@rand_8_hex = ensure_length(generate_hex(8).to_s(16).upcase, 4 * @@level)
		@@rand_8_hex = prepend_hex_id(@@rand_8_hex, 8)
		
		@@stable_dec1 = generate_dec(2)
		@@stable_dec2 = generate_dec(2)
	end

	def generate_type1 harder = false
		program_body = []
		
		if harder == true
			level = 2
		else
			level = @@level
		end
		
		program_body << 'int orig = ' + @@orig
		program_body << 'int insert = ' + @@insert
		program_body << 'int a = orig | (insert << ' + generate_dec(level) + ')'
		program_body << 'printf("%d", a)'
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
		program_body = []
		program_body << 'long testValue = ' + @@rand_8_hex
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
		program_body = generate_type7()
		program_body = remove_array_part program_body, [2]
		program_body.insert 2, 'if (testValue & testValue ^ (1 << ' + generate_dec(@@level) + '))'
	end
	
	def generate_type9
		program_body = generate_type7()
		program_body = remove_array_part program_body, [2]
		program_body.insert 2, 'int result = 0'
		program_body.insert 3, 'if ( (result = testValue & testValue ^ testValue | (1 << ' + generate_dec(@@level) + ')) )'
		program_body = append_to_array_end program_body, [], 'printf("[%d; %d]", a, result)'
	end
	
	def generate_type10 operator
		program_body = []
		
		program_body << 'int value1 = ' + generate_dec(@@level, true)
		program_body << 'int value2 = ' + generate_dec(@@level, true)
		program_body << 'int result = (value1 << ' + generate_dec(2) + ') ' + operator +  ' (value2 >> ' + generate_dec(@@level) + ')'
		program_body << 'printf("%d", result)'
	end
	
	def generate_all count, html_parser
		i = 0
		generated = []
		html_parser.add_style("questions")
		
		while i < count
			generated << generate_type1
			generated << generate_type1(true)
			generated << generate_type2
			generated << generate_type3
			generated << generate_type4
			generated << generate_type5
			generated << generate_type6
			generated << generate_type7
			generated << generate_type8
			generated << generate_type9
			generated << generate_type10("^")
			generated << generate_type10("|")
			
			number = i.to_s
			full_path = File.join(File.dirname(__FILE__), @@path + number)
			
			for i1 in 0..11
				file = (i1 + 1).to_s + ".c"
				@@c_parser.fill_file(generated[i1], @@path + number + "/questions/c/" + file)
				
				searched = remove_array_part generated[i1][generated[i1].length - 1].split(','), [0]
				
				searched.each do |searched_value|
					generated[i1].insert(0, searched_value.gsub(")", "") + ' = ?     .........................')
				end
				
				remove_array_part(generated[i1], [generated[i1].length - 1])
			end
			
			html_parser.create_question_html generated, @@path, number
			@@pdf_parser.send_html_to_pdf full_path + "/questions/" + "html/questions.html",
														full_path + "/questions/" + "pdf/questions.pdf"
			
			generated.clear
			i = i + 1
		end
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
	
	def generate_dec level, large = false
		rand = 0
		
		if large == true
			if level == 1
				rand = SecureRandom.random_number(1000) + 100
			else
				while (rand = SecureRandom.random_number(10000) + 1000) % 2 == 0 || rand == 1
				end
			end
		else				
			if level == 1
				rand = [2, 4, 8, 16].sample
			else
				while (rand = SecureRandom.random_number(18)) % 2 == 0 || rand == 1
				end
			end
		end
		
		rand.to_s
	end
	
	def append_to_array_end arr, info, new_end
		if new_end == 0
			array_end = arr[arr.length - 1]
		else
			array_end = new_end
		end
			
		arr.delete_at(arr.length - 1)
		info.each do |info_row|
			arr << info_row
		end
		
		arr << array_end
	end
	
	def remove_array_part array, indexes
		indexes.each do |index|
			array.delete_at(index)
		end
		
		array
	end
	
	def prepend_hex_id string, length = 0
		if @@level == 1 && length == 8
			string = string + string
		end
		
		string.insert 0, "x"
		string.insert 0, "0"
	end
	
end
