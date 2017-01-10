require './table.rb'
require './relation.rb'
require './column.rb'

class Parser

	def get_tasks strategy
		description_file = ARGV[0]
		tasks = [], []

		if strategy == 1
			tasks = get_tasks_strategy1 description_file, tasks
		elsif strategy == 2
			get_tasks_strategy2 description_file, tasks
		end

		tasks
	end

	def get_tasks_strategy1 description_file, tasks
		description = File.read description_file

		tasks = description.split "\n\n"

		for task in 0..tasks.length - 1
			lines = tasks[task].split "\n"

			lines.each do |line|
				if !is_line_needed line
					lines.delete(line)
				end
			end

			last_line = lines[lines.length - 1]
			lines.delete(last_line)

			tasks[task] = lines
		end
		
		tasks
	end

	def get_tasks_strategy2 description_file, tasks
		task_section = 0

		File.open(description_file, 'r').each do |line|
			task_section = change_task_section task_section, line, tasks
			
			if (1..2).include? task_section
				if is_line_needed line
					tasks[task_section - 1] << line
				end
			else
				break
			end
		end
	end

	def change_task_section task_section, line, tasks
		new_task_section = determine_task_section task_section, line

		if new_task_section != task_section
			if task_section != 0
				task = tasks[task_section - 1]
				last_line = task[task.length - 1]
				task.delete(last_line)
			end

			task_section = new_task_section
		end

		task_section
	end

	def determine_task_section prev_section, line
		task_section = prev_section

		for i in 1..9
			if line =~ /^\b#{i}\b\./
				task_section = i
				break
			end
		end

		task_section
	end

	def is_line_needed line
		is_needed = !(is_line_enumerated line)
		is_needed &&= line != "\n" 
	end

	def is_line_enumerated line
		regex = /^[0-9]\./

		if line =~ regex
			true
		else
			false
		end
	end

	def determine_initial_tables_to_create task
		tables = []
		current_table = ''

		task.each do |line|
			table_name = get_table_name line
			if table_name != nil
				table_name = get_table_name line
				current_table = Table.new table_name
			else
				table_columns = get_table_columns line
				current_table.columns = table_columns

				tables << current_table
			end
		end

		tables
	end

	def get_table_name line
		line = (line.split 'table')[1]
		if line != nil
			(line.split ' ')[0]
		else
			line
		end
	end

	def get_table_columns line
		columns = []
		line = (line.split "\t")

		line.each do |col|
			separator = find_separator_type col
			col = col.split separator
			if col && col.length > 1
				current_column = Column.new col[0], col[1]
				columns << current_column
			end
		end

		columns
	end

	def find_separator_type col
	  separators = ["->", ":", "=>"]
		suitable_separator = ':'

		separators.each do |s| 
			if col =~ /.+#{s}.+/
				suitable_separator = s
				break
			end
		end

		suitable_separator
	end

	def get_relations task
		relations = []

		task.each do |line|
			relations << (get_relation line)
		end

		relations
	end

	def get_relation line
		line = line.split ' '
		relation = Relation.new

		first_table_index = relation.get_first_table_index line
		second_table_index = relation.get_second_table_index line
		relation.first_table = line[first_table_index]
		relation.second_table = line[second_table_index]
		relation.first_table_relation_type = relation.find_table_relation_type(true, line)
		relation.second_table_relation_type = relation.find_table_relation_type(false, line)

		relation
	end

	def spread_relations task, tables
		relations = get_relations task

		relations.each do |relation|
			tables.each do |table|
				table.add_relation relation
			end
		end
	end

	def establish_relations tables, query_queue
		tables.each do |table|
			table.establish_relations query_queue
		end
	end

end



