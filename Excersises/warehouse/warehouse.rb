class Warehouse

	def initialize
		@SIDE_LENGTH_LOWER_BOUNDARY = 1
		@SIDE_LENGTH_UPPER_BOUNDARY = 100
		@side_length = 0
		@map = []

		get_arguments()
	end

	def check_side_length side_length
		if side_length > @SIDE_LENGTH_UPPER_BOUNDARY || side_length < @SIDE_LENGTH_LOWER_BOUNDARY
			puts "Invalid side length, must be between #{@SIDE_LENGTH_LOWER_BOUNDARY} and #{@SIDE_LENGTH_UPPER_BOUNDARY}"
			exit
		end
	end

	def has_sequel_array_member array, member, step = 1
		return array.include?(member + step)
	end
	
	def add_fake_row map
		row = (Array.new(@side_length) {0})
		map << row 
	end

	def get_arguments
		side_length = gets.chomp.to_i
		check_side_length(side_length)

		warehouse_rows = []

		for row in 1..side_length do
			warehouse_row = gets.chomp.split(' ').map(&:to_i)
			warehouse_rows << warehouse_row
		end

		@side_length = side_length
		@map = warehouse_rows
	end

	def get_routes
		routes = 0
		vertical_route_positions = []
		current_route_positions = []
		has_vertical_routes = true

		@map.each do |row|
			row.each_with_index do |place, i|
				if place == 0
					current_route_positions << i
				end
			end

			if current_route_positions.length == @side_length
				routes += 1
			end
			
			if vertical_route_positions.length == 0
				if current_route_positions.length == 0
					has_vertical_routes = false
				else
					vertical_route_positions = current_route_positions
				end
			elsif has_vertical_routes
				vertical_route_positions.each do |vpos|
					if !(current_route_positions.include? vpos)
						vertical_route_positions.delete(vpos)
					end
				end
			end
	
			current_route_positions = []
		end

		routes += vertical_route_positions.length

		routes
	end

	def get_stock_type_count
		type_count = 0
		current_stock_positions = []
		last_stock_positions = []
		map = add_fake_row(@map)

		map.each do |row|
			row.each_with_index do |place, i|
				if place == 1
					current_stock_positions << i
				end
			end

			if last_stock_positions.length != 0
				last_stock_positions.each do |lpos|
					if !(current_stock_positions.include? lpos)
						if !has_sequel_array_member(last_stock_positions, lpos)
							type_count += 1
						end
					end
				end
			end

			last_stock_positions = current_stock_positions
			current_stock_positions = []
		end

		type_count
	end

end
