require 'rubygems'
require 'rubygame'
require 'rubygoo'
require './create_gui.rb'
require "rubytrackselector"

include Rubygame
include Rubygoo
include CreateGui

class Game
	
	class Enemy
	
		attr_accessor :curr_x, :curr_y, :speed
		include Sprites::Sprite
		
		def initialize type
			@image1 = Surface.load 'models/Stuff/PacMan_1.png'
			@image2 = Surface.load 'models/Stuff/PacMan_2.png'
			
			@image3 = Surface.load 'models/Stuff/Eye_1.png'
			@image4 = Surface.load 'models/Stuff/Eye_2.png'
			@image5 = Surface.load 'models/Stuff/Eye_3.png'
			@image6 = Surface.load 'models/Stuff/Eye_4.png'
			@image7 = Surface.load 'models/Stuff/Eye_5.png'
			@image8 = Surface.load 'models/Stuff/Eye_6.png'
			
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

	class Player
	
		include Sprites::Sprite
		attr_accessor :breaker, :curr_x, :curr_y, :game_loss, :jump_trigger, :jump_ascending, :last_dir
		
		def initialize
			@image1 = Surface.load 'models/Stuff/Forward_1.png'
			@image2 = Surface.load 'models/Stuff/Forward_2.png'
			@image3 = Surface.load 'models/Stuff/Back_1.png'
			@image4 = Surface.load 'models/Stuff/Back_2.png'
			@image5 = Surface.load 'models/Stuff/Back_1.png'
			@image6 = Surface.load 'models/Stuff/Forward_1.png'
			
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
					when 42, 1337
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
					when 42, 1337
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

	def initialize
		@screen = Rubygame::Screen.new [1024,480], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
		@screen.title = "The trippy dino"
		@change_view = 0

		@queue = Rubygame::EventQueue.new
		@clock = Rubygame::Clock.new
		@clock.target_framerate = 30

		@first_iteration = 0
		@first_iteration_2 = 0
		
		@dino = Player.new
		@pac = Enemy.new 'pac'
		@eye = Enemy.new 'eye'
		@direction = 42
		@mul_click = 0
		@jump_lander = 0
		
		@background = generate_bg
		@death_screen = Surface.load "models/Backgrounds/game_over.png"
		
		@level_count = 1
		
		@dir_right = 0
		@dir_left = 0
		@dir_up = 0
		@presses = 0
		
		#Fonts
		TTF.setup
		filename = File.join(File.dirname(__FILE__), 'fonts', 'verdana.ttf')
		@verdana = TTF.new filename, 50

		#Music
		@rts = RTS::Rts.new
		@rts.local << File.join(File.dirname(__FILE__), "music")
		@rts.enable_local = true

		#UI
		@factory = AdapterFactory.new
		@render_adapter = @factory.renderer_for :rubygame, @screen
		@app = create_gui @render_adapter, @rts
		@app_adapter = @factory.app_for :rubygame, @app
	end
	
	def collision_check evil, good
		if (good.curr_y - 50 < evil.curr_y + 30 && good.curr_y + 50 > evil.curr_y - 30) &&
		(good.curr_x + 30 > evil.curr_x - 25 && good.curr_x - 30 < evil.curr_x + 25 &&
		 good.curr_x < evil.curr_x + 25)
			1
		else
			0
		end
	end
	
	def generate_bg
		case rand(3) + 1
			when 1
				#background_menu = Surface.load "models/Backgrounds/Background_1_dim.png"
				background = Surface.load "models/Backgrounds/Background_1.png"
			when 2
				#background_menu = Surface.load "models/Backgrounds/Background_2_dim.png"
				background = Surface.load "models/Backgrounds/background_2.png"
			when 3
				#background_menu = Surface.load "models/Backgrounds/Background_3_dim.png"
				background = Surface.load "models/Backgrounds/background_3.png"
		end
	end
	
	def achieve
		achv_check = false
		achv_1 = Surface.load "models/Achievement/The_Bolt.png"
		achv_2 = Surface.load "models/Achievement/The_Angry_Old_Guy.png"
		achv_3 = Surface.load "models/Achievement/Black_Spiderman.png"
		if achv_check == false
			if @dir_right >= 25 && @dir_right < 30
				achv_1.blit @screen,[650,20]
				achv_check = true
				@clock.target_framerate = 200
			elsif @dir_left >= 50 && @dir_left < 55
				achv_2.blit @screen,[650,20]
				achv_check = true
				@clock.target_framerate = 10
			elsif @dir_up >= 73 && @dir_up < 78
				achv_3.blit @screen,[650,20]
				achv_check = true
			end
		end
	end
	
	def check_life moved = 1
		if @dino.breaker == 0 && @dino.game_loss == 0	
			if moved == 1
				@background = @dino.move @direction, @background
			end
			
			if @background == 1337
				@dino.jump_trigger = 0
				@dino.curr_y = 350
				@dino.jump_ascending = 1
				@level_count = @level_count + 1
				@presses = @dir_left + @dir_right + @dir_up
				@background = generate_bg
				@eye.speed = (@pac.speed = @pac.speed + 2.5)
				@eye.reset 1
				@pac.reset 1
			end
		elsif @direction == 'w' || @dino.jump_trigger == 1
			if moved == 1
				@background = @dino.move @direction, @background
			end
		elsif @dino.game_loss != 0
			@presses = 0
			@level_count = 1
			@dir_left = 0
			@dir_right = 0
			@dir_up = 0
			@dino.jump_ascending = 1
			@dino.jump_trigger = 0
			@dino.curr_y = 350
			@dino.breaker = 0
			@background = generate_bg
			@eye.speed = (@pac.speed = 15)
			@eye.reset 1
			@pac.reset 1
			@dino.reset @background, 1
			@dino.move 'd', @background
			@screen.fill :black
			@death_screen.blit @screen, [300, 40]
			@change_view = -1
		end
	end

	def run
		loop do
			update
			draw
			@clock.tick
		end
	end

	def update
		@queue.each do |ev|
			case ev
				when Rubygame::QuitEvent
					Rubygame.quit
					exit

				when KeyDownEvent
					case ev.key
						when K_ESCAPE
							@change_view = 0
						when K_W
							@direction = 'w'
							@dir_up = @dir_up + 1
						when K_A, K_D
							if @direction != 42
								@mul_click = 1
							else
								@mul_click = 0
							end
							
							@dino.breaker = 0
							
							if K_A == ev.key
								@dino.last_dir = (@direction = 'a')
								@dir_left = @dir_left + 1
							elsif K_D == ev.key
								@dino.last_dir = (@direction = 'd')
								@dir_right = @dir_right + 1
							end
					end
				
				when KeyUpEvent
					case ev.key
						when K_A, K_D
							if @mul_click == 0
								@dino.breaker = 1
								@direction = 42
							else
								@mul_click = 0
							end
					end
			end

			@app_adapter.on_event ev
		end

		@app_adapter.update @clock.tick

		if @change_view == 1
			if @first_iteration == 0 && @rts.tag != RTS::LOADING
				@rts.tag = RTS::ACTION_SCENE
				@rts.play(:repeats => 100000)
				@first_iteration = 1
			else
				@first_iteration_2 = 0
			end
			
			@pac.move
			@eye.move
			
			@background.blit @screen, [0, 0]
			@dino.draw @screen
			@pac.draw @screen
			@eye.draw @screen
			
			if @presses + 3 > @dir_left + @dir_right + @dir_up
				level = @verdana.render "Level " + @level_count.to_s, true, [123,123,123]
				level.blit @screen, [450, 100]
			end
			
			@dino.game_loss = collision_check @pac, @dino
			check_life
			@dino.game_loss = collision_check @eye, @dino
			check_life 0
			
			if @direction == 'w'
				@direction = 1337
				@jump_lander = 1
			elsif @direction == 1337 && @dino.jump_trigger == 0 && @dino.last_dir == 42
				@direction = 42
			elsif @jump_lander == 1 && @dino.jump_trigger == 0
				@direction = 42
				@jump_lander = 0
			end
			
			achieve
		elsif @change_view == 0
			@app_adapter.draw @render_adapter
				
			if @first_iteration_2 == 0 && @rts.tag != RTS::LOADING
				@rts.tag = RTS::MENU
				@rts.play(:repeats => 100000)
				@first_iteration_2 = 1
			else
				@first_iteration = 0
			end
		elsif @change_view == -1
			sleep 3
			@change_view = 0
		end
	end

	def draw
		@screen.update
	end
end

game = Game.new
game.run
