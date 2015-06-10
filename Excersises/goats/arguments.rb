class Arguments

	attr_accessor :goats, :goat_count, :courses
	
	def initialize
		@MAX_GOAT_COUNT = 1000
		@MIN_GOAT_COUNT = 1
		@MAX_COURSES_COUNT = 1000
		@MIN_COURSES_COUNT = 1
		@MAX_GOAT_WEIGHT = 100000
		@MIN_GOAT_WEIGHT = 1

		@ERROR_MESSAGES = {
			:goat_count => "Invalid goat count, must be between #{@MIN_GOAT_COUNT} and #{@MAX_GOAT_COUNT}",
			:courses => "Invalid courses count, must be between #{@MIN_COURSES_COUNT} and #{@MAX_COURSES_COUNT}",
			:weight => "Invalid goat weight, must be between #{@MIN_GOAT_WEIGHT} and #{@MAX_GOAT_WEIGHT}",
		}

		@goats = []
		@goat_count = 0
		@courses = []
	end

	def check_goat_count goat_count = @goat_count
		if goat_count < @MIN_GOAT_COUNT || goat_count > @MAX_GOAT_COUNT
			puts @ERROR_MESSAGES[:goat_count] 
			exit
		end
	end

	def check_courses_count courses = @courses
		if courses < @MIN_COURSES_COUNT || courses > @MAX_COURSES_COUNT
			puts @ERROR_MESSAGES[:courses] 
			exit
		end
	end

	def check_goats_weight goats = @goats
		goats.each do |weight|
			if weight < @MIN_GOAT_WEIGHT || weight > @MAX_GOAT_WEIGHT 
				puts @ERROR_MESSAGES[:weight] 
				exit
			end
		end
	end

	def get_arguments
		count_and_courses = gets.chomp
		goats = gets.chomp

		count_and_courses = count_and_courses.split(" ")
		goat_count = count_and_courses[0].to_i
		courses = count_and_courses[1].to_i

		goats = goats.split(" ").map(&:to_i)
		goats = goats.sort()
		goats = goats.reverse()

		@goats = goats
		@goat_count = goat_count
		@courses = courses
	end

	def check_arguments
		check_goat_count()
		check_courses_count()
		check_goats_weight()
	end

end
