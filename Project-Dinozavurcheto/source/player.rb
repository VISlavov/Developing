class Player

	attr_accessor :breaker, :curr_x, :curr_y, :game_loss,
	 :jump_trigger, :jump_ascending, :last_dir, :image,
	 :image1, :image2, :image3, :image3, :image4, :image5, :image6,
	 :jump_ascending
	
	def initialize
		@image1 = Surface.load '../models/Stuff/Forward_1.png'
		@image2 = Surface.load '../models/Stuff/Forward_2.png'
		@image3 = Surface.load '../models/Stuff/Back_1.png'
		@image4 = Surface.load '../models/Stuff/Back_2.png'
		@image5 = Surface.load '../models/Stuff/Back_1.png'
		@image6 = Surface.load '../models/Stuff/Forward_1.png'
		
		@image = @image1
		
		@breaker = 1
		@game_loss = 0
		@curr_x = 74
		@curr_y = 350
		@rect = @image.make_rect
		@rect.center = [@curr_x, @curr_y]
		@speed = 30
		@jump_height = 300
		@jump_speed = 10
		@jump_trigger = 0
		@jump_ascending = 1
		@last_dir = ''
	end
	
	def reset bg, mandatory = 0
		if @curr_x >= 1024 || mandatory != 0
			@curr_x = -20
			1337
		else
			bg
		end
	end

	def change_frame mode, jump
		if jump == 1
			case mode
				when 'd'
					@image = @image6
				when 'a'
					@image = @image5
				else
					return 0
			end
		else
			case mode
				when 'd'
					image1 = @image1
					image2 = @image2
				when 'a'
					image1 = @image3
					image2 = @image4
				else
					return 0
			end
			
			case @image
				when @image5
					@image = image1
				when @image6
					@image = image2
				when @image2, @image4
					@image = image1
				when @image1, @image3
					@image = image2
				else
					return 0
			end
		end
	end
	
	def jump
		if @curr_y > @jump_height
			if @jump_ascending == 1
				@rect.center = [@curr_x, @curr_y = @curr_y - @jump_speed]
			elsif @jump_ascending == -1
				@rect.center = [@curr_x, @curr_y = @curr_y + @jump_speed]
			end
		elsif @curr_y = @jump_height
			@jump_ascending = -1
			@curr_y = @curr_y + @jump_speed
		end
		
		@curr_y
	end
	
	def move dir, bg
		cycle = 1
		
		while cycle == 1
			case dir
				when 'w', 1337
					if dir == 'w'
						@jump_trigger = 1
					end
					if @last_dir != 'a' && @last_dir != 'd'
						cycle = 0
					elsif @breaker == 0
						dir = @last_dir
					else
						@last_dir = 42
						cycle = 0
					end
				when 'a'
					if @curr_x > -46
						@rect.center = [@curr_x = @curr_x - @speed, @curr_y]
					end
					cycle = 0
				when 'd'
					@rect.center = [@curr_x = @curr_x + @speed, @curr_y]
					cycle = 0
				else
					cycle = 0
			end
		end
		
		if @jump_trigger == 1
			if jump == 350
				@jump_trigger = 0
				@jump_ascending = 1
			end
		end
		
		change_frame dir, @jump_trigger
		
		reset bg
	end
	
end
