class Table

	attr_accessor :name, :columns, :relations, :is_many_to_many_bridge

	@@tables = []

	def initialize name = '', columns = [], is_many_to_many_bridge = false
		@name = format_name name
		@columns = columns
		@is_many_to_many_bridge = is_many_to_many_bridge
		@relations = []
		@@tables << self
	end

	def self.get_tables
		@@tables
	end

	def	self.print_tables
		@@tables.each do |table|
			puts table.name
		end
	end
	
	def self.is_existing name
		is_existing = false

		@@tables.each do |table|
			if name == table.name
				is_existing = true
			end
		end

		is_existing
	end

	def insert_dummy_values number_base = 1, dynamic_number_base = false
		query_assembler = QueryAssembler.new
		values = generate_dummy_values number_base, dynamic_number_base
		
		query = query_assembler.insert_dummy_values self, values

		query
	end

	def generate_dummy_values number_base = 1, dynamic_number_base = false
		data = ""
		first_run = true
		number_base_options_reflection = [5, 4, 3, 2, 1]

		@columns.each do |column|
			if first_run
				first_run = false
			else
				if dynamic_number_base
					number_base = number_base_options_reflection[number_base - 1]
				end

				data += ", "
			end

			data += column.generate_dummy_value number_base
		end		
		
		data
	end
	
	def get_column_names
		names = ""
		first_run = true

		@columns.each do |column|
			if first_run
				first_run = false
			else
				names += ", "
			end
			
			names += column.name
		end
		
		names
	end

	def format_name name
		if name == "User"
			name += '1'
		end

		name
	end

	def add_relation relation
		relation.first_table = format_name relation.first_table
		relation.second_table = format_name relation.second_table

		if (relation.first_table == @name) || (relation.second_table == @name)
			relations << relation
		end
	end

	def establish_relations query_queue
		query_assembler = QueryAssembler.new

		@relations.each do |relation|
			query_assembler.establish_relation relation, query_queue
		end
	end

	def self.compose_table_id_col_name table_name
		id_col_name = table_name.downcase() + "_id"

		id_col_name
	end

	def self.compose_common_table_name first_table_name, second_table_name
		name = first_table_name.downcase() + "_" + second_table_name.downcase()

		name
	end

end
