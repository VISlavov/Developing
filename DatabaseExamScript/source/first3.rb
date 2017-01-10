#ruby first3.rb ../victor_slavov_12b/task exam31 2 solution ../../db-derby-10.11.1.1-bin/bin/ ../victor_slavov_12b/

require './solver.rb'
require './executor.rb'

solver = Solver.new

solver.solve_first_task
solver.solve_second_task
solver.solve_third_task

executor = Executor.new solver.query_queue

executor.create_query_container_file
executor.execute_queries
