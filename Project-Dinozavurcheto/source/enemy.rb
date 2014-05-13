class Enemy

	attr_accessor :curr_x, :curr_y, :speed
	
	def initialize type
		@image1 = Surface.load '../models/Stuff/PacMan_1.png'
		@image2 = Surface.load '../models/Stuff/PacMan_2.png'
		
		@image3 = Surface.load '../models/Stuff/Eye_1.png'
		@image4 = Surface.load '../models/Stuff/Eye_2.png'
		@image5 = Surface.load '../models/Stuff/Eye_3.png'
		@image6 = Surface.load '../models/Stuff/Eye_4.png'
		@image7 = Surface.load '../models/Stuff/Eye_5.png'
		@image8 = Surface.load '../models/Stuff/Eye_6.png'
		
		if type == 'pac'
			@image = @image1
		elsif type == 'eye'
			@image = @image3
		end
			
		@curr_x = rand 1300
		@curr_y = 0
		@rect = @image.make_rect
		@rect.center = [@curr_x, @curr_y]
		@speed = 15
	end
	
	def reset mandatory = 0
		if (@curr_x < 0 || @curr_y > 800) || mandatory == 1
			@curr_x = rand(400) + rand(400) + rand(42) + rand(200) + rand(200)
			@curr_y = 0
		end
	end

	def move
		case @image
			when @image7
				@image = @image3
			when @image6
				@image = @image7
			when @image5
				@image = @image6
			when @image4
				@image = @image5
			when @image3
				@image = @image4
			when @image2
				@image = @image1
			when @image1
				@image = @image2
		end
		
		@rect.center = [@curr_x = @curr_x - @speed / 1.5, @curr_y = @curr_y + @speed]
		
		reset
	end
	
end
