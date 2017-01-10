class QueryQueue

	def initialize queries = []
		@queries = queries
	end

	def push query
		@queries << query
	end

	def pop
		first = @queries[0]
		if first
			@queries.delete(first)
		end

		first
	end

	def print
		nxt = pop()
		while nxt
			puts nxt
			nxt = pop()
		end
	end

end