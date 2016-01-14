require './parser.rb'
require './query_assembler.rb'
require './query_queue.rb'
require './table.rb'
require './relation.rb'

class Solver

	attr_accessor :query_queue

	def initialize
		@parser = Parser.new
		@query_queue = QueryQueue.new
		@query_assembler = QueryAssembler.new
		
		tasks = @parser.get_tasks 2

		@first_task = tasks[0]
		@second_task = tasks[1]
		@parser.determine_initial_tables_to_create @first_task
	end

	def solve_first_task
		query = @query_assembler.connect()
		@query_queue.push query

		Table.get_tables.each do |table|
			query = @query_assembler.create_table table
			@query_queue.push query
		end

	end

	def solve_second_task
		@parser.spread_relations @second_task, Table.get_tables
		@parser.establish_relations Table.get_tables, @query_queue
	end

	def solve_third_task
		Table.get_tables.each do |table|
			(1..5).each do |num|
				query =	table.insert_dummy_values num
				@query_queue.push query
			end

			if table.is_many_to_many_bridge
				(1..5).each do |num|
					query =	table.insert_dummy_values num, true
					@query_queue.push query
				end
			end
		end
	end

end
