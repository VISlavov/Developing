def get_next_appropriate_goat_index remaining_capacity, goats
	index = false

	if goats.length != 0 && remaining_capacity > 0
		goats.each_with_index do |goat, i|
			if remaining_capacity >= goat
				index = i
				break
			else
				next
			end
		end
	end

	index
end

def make_course capacity, remaining_goats
	current_capacity = remaining_goats[0]
	remaining_goats.delete_at(0)

	while true do
		remaining_capacity = capacity - current_capacity
		goat_index = get_next_appropriate_goat_index(remaining_capacity, remaining_goats)

		if goat_index != false
			goat = remaining_goats[goat_index]	

			current_capacity += goat
			remaining_goats.delete_at(goat_index)	
			if current_capacity == capacity
				break
			end
		else
			break
		end
	end

	remaining_goats
end

def make_courses capacity, courses, goats
	while courses > 0
		goats = make_course(capacity, goats)
		
		if goats.length == 0
			break
		end

		courses -= 1
	end

	goats
end 

def deep_clone_collection collection
	cloned_collection = []
	collection.each do |elem|
		cloned_collection << elem
	end

	cloned_collection
end

def find_needed_capacity arguments
	goats = deep_clone_collection(arguments.goats)
	goat_count = arguments.goat_count
	courses = arguments.courses
	capacity = goats[0]
	unserviced_goats_count = make_courses(capacity, courses, goats).length
	iterations = 0

	while	unserviced_goats_count != 0 do
		capacity += unserviced_goats_count
		#capacity += 1
		iterations += 1
		goats = deep_clone_collection(arguments.goats)
		unserviced_goats_count = make_courses(capacity, courses, goats).length
	end
	
	puts iterations
	capacity
end
