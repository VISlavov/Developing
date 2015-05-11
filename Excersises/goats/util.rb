def get_next_course_members_end_boundary capacity, index, goats
	current_capacity = 0
	
	while current_capacity < capacity
		if index == goats.length
			break
		end

		current_capacity += goats[index]
		index += 1
	end

	index
end

def find_needed_capacity arguments
	goats = arguments.goats
	goat_count = arguments.goat_count
	courses = arguments.courses
	boundary = 0
	
	capacity = goats[0]
	
	if goat_count > courses
		while boundary != goats.length - 1
			courses_made = 1
			boundary = 0
			capacity += 1

			while courses_made < courses
				boundary = get_next_course_members_end_boundary(capacity, boundary, goats)
				courses_made += 1
				puts 'haha' + boundary.to_s + 'hhaha' + capacity.to_s
			end

			puts boundary
			puts goats.length
			puts courses_made
			puts courses
			puts "----"
		end
	end

	capacity
end
