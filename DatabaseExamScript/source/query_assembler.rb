require './table.rb'
require './column.rb'

class QueryAssembler

	def initialize
		@db_name = ARGV[1]
	end

	def connect
		query = "connect 'jdbc:derby:#{@db_name};create=true';"

		query
	end

	def create_table table, add_id = true, add_composite_key = false
		query = "create table #{table.name} ("

		if add_id
			table.columns.insert(0, Column.new("id", "int", "primary key"))
		end

		first_pass = true		

		table.columns.each do |col|
			if first_pass == true
				first_pass = false
			else
				query += ", "
			end

			query += "#{col.name} #{col.type}"

			if col.constraints != ''
				query += " #{col.constraints}"
			end
		end

		if add_composite_key
			first_col = table.columns[0].name
			second_col = table.columns[1].name
			query += ", primary key (#{first_col}, #{second_col})"
		end

		query += ');'

		query
	end

	def establish_relation relation, query_queue
		relation_types = relation.RELATION_TYPES
		relation_type = relation.determine_relation_type

		case relation_type
			when relation_types[0]
				establish_one_to_one relation, query_queue
			when relation_types[1]
				establish_one_to_many relation, query_queue
			when relation_types[2]
				establish_many_to_one relation, query_queue
			when relation_types[3]
				establish_many_to_many relation, query_queue
		end
	end

	def establish_one_to_one relation, query_queue
		col_type = "int"
		col_constraints = "unique"
		first_query = alter relation.first_table, Table.compose_table_id_col_name(relation.second_table), col_type, "add", col_constraints
		second_query = alter relation.second_table, Table.compose_table_id_col_name(relation.first_table), col_type, "add", col_constraints

		query_queue.push(first_query)
		query_queue.push(second_query)
	end

	def establish_one_to_many relation, query_queue
		query = alter(relation.second_table, Table.compose_table_id_col_name(relation.first_table), "int")

		query_queue.push(query)
	end

	def establish_many_to_one relation, query_queue
		query = alter(relation.first_table, Table.compose_table_id_col_name(relation.second_table), "int")

		query_queue.push(query)
	end

	def establish_many_to_many relation, query_queue
		table = init_many_to_many_table relation
		
		if table
			query = create_table(table, false, true)

			query_queue.push(query)
		end
	end

	def init_many_to_many_table relation
		table_name = Table.compose_common_table_name(relation.first_table, relation.second_table)

		if (Table.is_existing table_name)	
			false
		else
			columns = []

			columns << (Column.new (Table.compose_table_id_col_name relation.first_table), "int")
			columns << (Column.new (Table.compose_table_id_col_name relation.second_table), "int")

			table = Table.new table_name, columns, true

			table		
		end
	end

	def alter table_name, col, col_type, action = "add", col_constraints = ''
		query = "alter table #{table_name} #{action} column #{col} #{col_type}"
		has_constraints = col_constraints != ''		

		if has_constraints
			query += " #{col_constraints}"
		end
		
		if action == "add"
			table = Table.get_tables.select{ |t| t.name == table_name }
			if table.length > 0
				table = table[0]
			else
				return -1
			end

			column = has_constraints ? Column.new(col, col_type, col_constraints) : Column.new(col, col_type)
			has_column = (table.columns.select{ |c| c.name == column.name }).length > 0

			if has_column == false
				table.columns << column
			end
		end

		query += ";"

		query
	end

	def insert_dummy_values table, values 
		column_names = table.get_column_names

		query = "insert into #{table.name} (#{column_names}) values(#{values});"
		
		query
	end

end
