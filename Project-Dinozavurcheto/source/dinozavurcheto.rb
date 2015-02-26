class Game

	attr_accessor :dir_up, :dir_right, :dir_left, :level_count, :change_view
	
	def initialize
		@screen = Rubygame::Screen.new [1024,480], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
		@screen.title = "The trippy dino"
		@change_view = 0

		@queue = Rubygame::EventQueue.new
		@clock = Rubygame::Clock.new
		@clock.target_framerate = 30

		@first_iteration = 0
		@first_iteration_2 = 0
		@up_first_it = 0
		@left_first_it = 0
		@right_first_it = 0
		
		@dino = Player.new
		@pac = Enemy.new 'pac'
		@eye = Enemy.new 'eye'
		@direction = 42
		@mul_click = 0
		@jump_lander = 0
		@jump_blocker = 0
		
		@background = generate_bg
		@death_screen = Surface.load "../models/Backgrounds/game_over.png"
		
		@level_count = 1
		@gained_achievements = Array.new()
		@gained_achievements[0] = "No Achievements Gained"
		@achievements_count = 0
		
		@dir_right = 0
		@dir_left = 0
		@dir_up = 0
		@presses = 0
		
		#Fonts
		TTF.setup
		filename = File.join(File.dirname(__FILE__), '../fonts', 'verdana.ttf')
		@verdana = TTF.new filename, 50

		#Music
		@rts = RTS::Rts.new
		@rts.local << File.join(File.dirname(__FILE__), "../music")
		@rts.enable_local = true

		#UI
		@factory = AdapterFactory.new
		@render_adapter = @factory.renderer_for :rubygame, @screen
		@app = create_gui @render_adapter, @rts
		@app_adapter = @factory.app_for :rubygame, @app
		@label = ''
		@level_lavel = ''
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
				#background_menu = Surface.load "../models/Backgrounds/Background_1_dim.png"
				background = Surface.load "../models/Backgrounds/Background_1.png"
			when 2
				#background_menu = Surface.load "../models/Backgrounds/Background_2_dim.png"
				background = Surface.load "../models/Backgrounds/background_2.png"
			when 3
				#background_menu = Surface.load "../models/Backgrounds/Background_3_dim.png"
				background = Surface.load "../models/Backgrounds/background_3.png"
		end
	end
	
	def achieve
		achv_check = false
		achv_1 = Surface.load "../models/Achievement/The_Bolt.png"
		achv_2 = Surface.load "../models/Achievement/The_Angry_Old_Guy.png"
		achv_3 = Surface.load "../models/Achievement/Black_Spiderman.png"
		if achv_check == false
			if @dir_right == 25
				achv_1.blit @screen,[650,20]
				achv_check = true
				if @right_first_it == 0
					@clock.target_framerate = 100
					@gained_achievements[@achievements_count] = 'The Bolt'
					@achievements_count = @achievements_count + 1
					@right_first_it = 1
				end
			elsif @dir_left == 50
				achv_2.blit @screen,[650,20]
				achv_check = true
				if @left_first_it == 0
					@clock.target_framerate = @clock.target_framerate - 15
					@gained_achievements[@achievements_count] = 'The Angry Old Guy'
					@achievements_count = @achievements_count + 1
					@left_first_it = 1
				end
			elsif @dir_up == 73
				achv_3.blit @screen,[650,20]
				achv_check = true
				if @up_first_it == 0
					@jump_blocker = 1
					@gained_achievements[@achievements_count] = 'The Black Spiderman'
					@achievements_count = @achievements_count + 1
					@up_first_it = 1
				end
			end
		end
	end
	
	def write_csv file, data
		i = 0
		CSV.open(file, "w") do |file|
			file << ['Level ' + @level_count.to_s]
			while i < data.length
				file << [data[i]]
				i = i + 1
			end
		end
	end
	
	def parse_csv file, rows
		if rows == 'all'
			start_rows = 0
		else
			start_rows = rows
		end
		
		data = Array.new()
		
		CSV.foreach(file) do |row|
			if rows == 'all'
				data[start_rows] = row.inspect
				start_rows = start_rows + 1
			else				
				data[start_rows - rows] = row.inspect
				
				rows = rows - 1
				if rows == 0
					return data
				end
			end
		end
		
		data
	end
	
	def find_empty_save save1, save2, save3, first_run = 0
		i = 1
		if first_run == 0
			target_save = 1337
		else
			target_save = 42
		end
		
		while i <= 3
			if !(File.exist?('save' + i.to_s + '.csv'))
				if target_save != 1337
					case i
						when 1
							save1.hide
						when 2
							save2.hide
						when 3
							save3.hide
					end
				else
					target_save = i
					
					case target_save
						when 1
							save1.show
						when 2
							save2.show
						when 3
							save3.show
					end
				end
			end
			
			i = i + 1
		end
		
		target_save
	end
	
	def show_save_content num, modal, save_button, shown
		if shown != 0
			@label.hide
			@level_label.hide
			@delete_butt.hide
			@load_butt.hide
		end
		
		@label = TextField.new("Save " + num.to_s + ":", :x=>350, :y=>30, :padding_left=>10, :relative=>true)
		@level_label = TextField.new((parse_csv 'save' + num.to_s + '.csv', 1)[0].tr('[]""', ''), :x=>330, :y=>70, :padding_left=>10, :relative=>true)
		@delete_butt = Button.new("Delete", :x=>300, :y=>130, :padding_left=>10, :padding_top=>10, :relative=>true)
		@load_butt = Button.new("Load", :x=>430, :y=>130, :padding_left=>10, :padding_top=>10, :relative=>true)
		
		@delete_butt.on :pressed do |*opts|
			File.delete('save' + num.to_s + '.csv')
			@delete_butt.hide
			@load_butt.hide
			@level_label.hide
			@label.hide
			save_button.hide
		end
		
		@load_butt.on :pressed do |*opts|
			saved_data = parse_csv ('save' + num.to_s + '.csv'), 'all'
			
			i = 1
			while i < saved_data.length
				if i == 7
					saved_data[i] = saved_data[i].to_s.tr('"[]\\', '').split(', ')
				else
					saved_data[i] = saved_data[i].tr('"[]', '').to_i
				end
				i = i + 1
			end
			
			@eye.speed = saved_data[1]
			@pac.speed = saved_data[2]
			@clock.target_framerate = saved_data[3]
			@jump_blocker = saved_data[4]
			@presses = saved_data[5]
			@level_count = saved_data[6]
			
			i = 0
			while i < saved_data[7].length
				@gained_achievements[i] = saved_data[7][i]
				i = i + 1
			end		
						
			@dir_left = saved_data[8]
			@dir_right = saved_data[9]
			@dir_up = saved_data[10]
			@right_first_it = saved_data[11]
			@left_first_it = saved_data[12]
			@up_first_it = saved_data[13]
			@change_view = 1
		end
		
		modal.add @delete_butt, @load_butt, @label, @level_label
		
		if shown != 0
			@load_butt.show
			@delete_butt.show
		end
		
		num
	end
	
	def set_highscore
		if File.exist?('highscore.csv')		
			if (parse_csv 'highscore.csv', 1).to_s.split(' ')[1].tr('"]', '').to_i < @level_count
				write_csv "highscore.csv", @gained_achievements
			end
		else
			write_csv "highscore.csv", @gained_achievements
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
				@dino.move 'd', @background
				@eye.speed = (@pac.speed = @pac.speed + 2.5)
				@eye.reset 1
				@pac.reset 1
			end
		elsif @direction == 'w' || @dino.jump_trigger == 1
			if moved == 1
				@background = @dino.move @direction, @background
			end
		elsif @dino.game_loss != 0
			set_highscore
			@clock.target_framerate = 30
			@jump_blocker = 0
			@presses = 0
			@level_count = 1
			@gained_achievements = Array.new()
			@gained_achievements[0] = "No Achievements Gained"
			@achievements_count = 0
			@right_first_it = 0
			@left_first_it = 0
			@up_first_it = 0
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
							if @jump_blocker == 0							
								@direction = 'w'
							end
							@dir_up = @dir_up + 1
						when K_A, K_D
							if @direction == 'a' || @direction == 'd' || (@direction == 1337 && @dino.breaker == 0)
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
				@jump_lander = 0
			elsif @jump_lander == 1 && @dino.jump_trigger == 0
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
