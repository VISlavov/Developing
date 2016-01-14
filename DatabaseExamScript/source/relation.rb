class Relation

	attr_accessor :first_table, :second_table, :first_table_relation_type, :second_table_relation_type, :RELATION_TYPES

	def initialize
		@KEYWORDS = ['one', 'many']

		@RELATION_TYPES = [
			'one to one',
			'one to many',
			'many to one',
			'many to many',
		]

		@first_table = ''
		@first_table_relation_type = ''
		@second_table = ''
		@second_table_relation_type = ''
	end

	def determine_relation_type
		type = ''

		if (@first_table_relation_type == @KEYWORDS[0]) && (@second_table_relation_type == @KEYWORDS[0])
			type = @RELATION_TYPES[0]
		elsif (@first_table_relation_type == @KEYWORDS[0]) && (@second_table_relation_type == @KEYWORDS[1])
			type = @RELATION_TYPES[1]
		elsif (@first_table_relation_type == @KEYWORDS[1]) && (@second_table_relation_type == @KEYWORDS[0])
			type = @RELATION_TYPES[2]
		elsif (@first_table_relation_type == @KEYWORDS[1]) && (@second_table_relation_type == @KEYWORDS[1])
			type = @RELATION_TYPES[3]
		end

		type
	end

	def get_first_table_index line
		first_table_index = 0
		
		first_table_index
	end

	def get_second_table_index line
		second_table_index = line.length - 1

		second_table_index
	end

	def find_table_relation_type is_first, line
		if is_first
			boundary = line.length
			i = (get_first_table_index line) + 1
			increment = 1
		else
			boundary = 0
			i = (get_second_table_index line) - 1
			increment = -1
		end
		
		while i != boundary 
			word = line[i]
			if is_keyword word
				relation_type = word
				break
			end

			i += increment
		end

		relation_type
	end

	def is_keyword word
		is_keyword = false

		@KEYWORDS.each do |keyword|
			if word == keyword
				is_keyword = true
				break
			end
		end

		is_keyword
	end

	def print
		puts @first_table
		puts @first_table_relation_type
		puts @second_table
		puts @second_table_relation_type
		puts '-------'
	end

end