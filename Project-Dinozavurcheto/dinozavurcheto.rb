#!/bin/env ruby

require 'rubygems'
require 'rubygame'
require 'rubygoo'
require './create_gui.rb'
require "rubytrackselector"
Rubygame::TTF.setup

include Rubygame
include Rubygoo
include CreateGui

class Game
	def collision_check evil, good
		if (good.curr_x + 30 < evil.curr_x + 30 && good.curr_x + 30 > evil.curr_x - 30) && 
		(good.curr_y + 30< evil.curr_y + 30 && good.curr_y + 30 > evil.curr_y - 30)
			1
		else
			0
		end
	end	
	
	class Text
		def initialize x=100, y=100, text="Hello, World!", size=48
			@font = Rubygame::TTF.new "fonts/verdana.ttf", size
			@text = text
		end
		
		def rerender_text
			@width,@height = @font.size_text(@text)
			@surface = @font.render(@text, true, [255, 255, 255])
		end
		
		def text string
			@text = string
			rerender_text
		end
	end

	
	class Enemy
		attr_accessor :curr_x, :curr_y
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
			@speed = 30
		end

		def move bg_pos
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
			@rect.center = [@curr_x = @curr_x + bg_pos, @curr_y = @curr_y + @speed]
			puts bg_pos
			if @curr_x < 0 && @curr_y > 1000
				@curr_x = rand(400) + rand(400) + rand(42)
				@curr_y = 0
			end
		end
	end

	class Player
		include Sprites::Sprite
		attr_accessor :breaker, :curr_x, :curr_y
		
		def initialize
			@image1 = Surface.load 'models/Stuff/Forward_1.png'
			@image2 = Surface.load 'models/Stuff/Forward_2.png'
			@image3 = Surface.load 'models/Stuff/Back_1.png'
			@image4 = Surface.load 'models/Stuff/Back_2.png'
			@image = @image1
			
			@breaker = 1
			@curr_x = 74
			@curr_y = 350
			@rect = @image.make_rect
			@rect.center = [@curr_x, @curr_y]
			@speed = 30
			@jump_height = 30
		end

		def change_frame mode
			case mode
				when 'd'
					image1 = @image1
					image2 = @image2
				when 'a'
					image1 = @image3
					image2 = @image4
			end
			
			case @image
				when @image2, @image4
					@image = image1
				when @image1, @image3
					@image = image2
			end
		end
		
		def jump
		
		end
		
		def move dir, bg_pos
			case dir
				when 'w'
					#@rect.center = [@curr_x, @curr_y = @curr_y - @jump_height]
					#sleep 0.42
					#@rect.center = [@curr_x, @curr_y = @curr_y + @jump_height]
				when 'a'
					if @curr_x < 440
						@rect.center = [@curr_x = @curr_x - @speed, @curr_y]
					else
						bg_pos = bg_pos + @speed
						@curr_x = @curr_x - bg_pos
					end
				when 'd'
					if @curr_x < 440
						@rect.center = [@curr_x = @curr_x + @speed, @curr_y]
					else
						bg_pos = bg_pos - @speed
						@curr_x = @curr_x + (bg_pos * -1)
					end
			end
			
			change_frame dir
			
			bg_pos
		end
	end

	def initialize
		@screen = Rubygame::Screen.new [880,480], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
		@screen.title = "Trippy dino"

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
		@bg_x = 0
		
		@text = Text.new

		# Background
		case rand(3) + 1
			when 1
				@background = Surface.load "models/Backgrounds/Background_1.png"
				#background_menu = Surface.load "models/Backgrounds/Background_1_dim.png"
			when 2
				@background = Surface.load "models/Backgrounds/background_2.png"
				#background_menu = Surface.load "models/Backgrounds/Background_2_dim.png"
			when 3
				@background = Surface.load "models/Backgrounds/background_3.png"
				#background_menu = Surface.load "models/Backgrounds/Background_3_dim.png"
		end

		#Music
		@rts = RTS::Rts.new
		@rts.local << File.join(File.dirname(__FILE__), "music")
		@rts.enable_local = true

		#UI
		@factory = AdapterFactory.new
		@render_adapter = @factory.renderer_for :rubygame, @screen
		@app = create_gui(@render_adapter, @rts, @screen)
		@app_adapter = @factory.app_for :rubygame, @app
	end
	
	def achieve
		achv_check = false
		@dir_right = 4
		@dir_left = 4
		@dir_up = 4
		achv_1 = Surface.load "models/Achievement/The_Bolt.png"
		achv_2 = Surface.load "models/Achievement/The_Angry_Old_Guy.png"
		achv_3 = Surface.load "models/Achievement/Black_Spiderman.png"
		if achv_check == false
			if @dir_right == 5 && @dir_left != 5 && @dir_up != 5
				achv_1.blit @screen,[650,20]
				achv_check = true
			elsif @dir_right != 5 && @dir_left == 5 && @dir_up != 5
				achv_2.blit @screen,[650,20]
				achv_check = true
			elsif @dir_right != 5 && @dir_left != 5 && @dir_up == 5
				achv_3.blit @screen,[650,20]
				achv_check = true
			else
				@dir_right = 0
				@dir_left = 0
				@dir_up = 0
			end
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
							@bg_x = @dino.move 'w', @bg_x
						when K_A, K_D
							if @direction != 42
								@mul_click = 1
							else
								@mul_click = 0
							end
							
							@dino.breaker = 0
							
							if K_A == ev.key
								@direction = 'a'
							elsif K_D == ev.key
								@direction = 'd'
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
			
			if @dino.breaker == 0
				@bg_x = @dino.move @direction, @bg_x
			end
			
			@pac.move @bg_x
			@eye.move @bg_x
			
			@background.blit @screen, [@bg_x, 0]
			@dino.draw @screen
			@pac.draw @screen
			@eye.draw @screen
			
			puts ' ------------------------- '
			puts collision_check @pac, @dino
			puts ' ------ '
			puts collision_check @eye, @dino
			puts ' ------------------------- '
			
			@text.text rand(100).to_s
			
			achieve
		else
			@app_adapter.draw @render_adapter
				
			if @first_iteration_2 == 0 && @rts.tag != RTS::LOADING
				@rts.tag = RTS::MENU
				@rts.play(:repeats => 100000)
				@first_iteration_2 = 1
			else
				@first_iteration = 0
			end
		end
	end

	def draw
		@screen.update
	end
end

game = Game.new
game.run
