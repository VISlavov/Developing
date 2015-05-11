class Arguments

	attr_accessor :goats, :goat_count, :courses
	
	def initialize
		@goats = []
		@goat_count = 0
		@courses = []
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

end
