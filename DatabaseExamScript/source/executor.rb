class Executor
	
	def initialize query_queue
		@query_queue = query_queue
		@exam_file_name = ARGV[3]
	end

	def create_query_container_file
		File.open(@exam_file_name, "w") do |f|
			nxt = @query_queue.pop()
			while nxt
				f << nxt
				f << "\n"	
				nxt = @query_queue.pop()
			end
		end
	end

	def execute_queries
		ij_dir = ARGV[4]
		#`#{ij_dir}/ij < #{@exam_file_name}`

		exam_dir = ARGV[5]
		#`mv #{@exam_file_name} #{exam_dir}`
		`mv #{@exam_file_name} #{ij_dir}`
		#`mv #{ARGV[1]} #{ij_dir}`
		#`mv 'derby.log' #{ij_dir}`
	end

end
