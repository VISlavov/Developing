module CreateGui
  def create_gui renderer, music
    app = App.new :renderer => renderer

	@button = Button.new "Start/Continue game", :x=>70, :y=>80, :w=>200, :h=>100, :padding_left=>20, :padding_top=>20
	
	@button.on :pressed do |*opts|
		@change_view = 1
	end

    grp1 = RadioGroup.new :x=>450, :y=>150, :padding_left=>20, :padding_top=>20, :w=> 170, :h=>100

    grp_label1 = Label.new "Yes:", :x=>17, :y=>40, :w=>10, :h=>10, :relative=>true
    grp_label2 = Label.new "No:", :x=>85, :y=>40, :w=>10, :h=>10, :relative=>true
    grp_label3 = Label.new "Enable music:", :x=>13, :y=>2, :w=>210, :h=>10, :relative=>true
    grp_radio_one = RadioButton.new :x=>30, :y=>68, :w=>10, :h=>20, :relative=>true
    grp_radio_two = RadioButton.new :x=>100, :y=>68, :w=>10, :h=>20, :relative=>true
    
    
    @disable_second = 42
    
	grp_radio_one.on :checked do
		if @disable_second == 0	|| @disable_second == 42
			music.tag = RTS::MENU
			music.play(:repeats => 100000)
			if @disable_second == 42
				@disable_second = 0
			else
				@disable_second = 1
			end
		else
			@disable_second = 0
		end
	end
	
	grp_radio_two.on :checked do
		if @disable_second == 0	|| @disable_second == 42
			music.tag = RTS::LOADING
			music.play(:repeats => 100000)
			if @disable_second == 42
				@disable_second = 0
			else
				@disable_second = 1
			end
		else
				@disable_second = 0
		end
	end
	
	grp1.add grp_label1, grp_label2, grp_label3, grp_radio_one, grp_radio_two

    modal_button_settings = Button.new "Settings", :x=>70, :y=>240, :padding_left=>20, :padding_top=>20
	modal_button_settings.on :pressed do |*opts|
	
		modal = Dialog.new :modal => app, :x=>400, :y=>110, :w=>350, :h=>250
		modal.add grp1
		
		ok_butt = Button.new("OK", :x=>180, :y=>180, :padding_left=>20, :padding_top=>20,:relative=>true)
		ok_butt.on :pressed do |*opts|
			modal.close
		end
		
		modal.add ok_butt
		
		modal.display
	end
    
    modal_button = Button.new "Help", :x=>70, :y=>160, :padding_left=>20, :padding_top=>20
	modal_button.on :pressed do |*opts|
		modal = Dialog.new :modal => app, :x=>400, :y=>110, :w=>350, :h=>250

		modal.add Label.new("Controls: ", :x=>20, :y=>10, :padding_left=>10, :padding_top=>10, :relative=>true)
		modal.add TextField.new("W - up", :x=>20, :y=>70, :padding_left=>10, :padding_top=>10, :relative=>true)
		modal.add TextField.new("S - down", :x=>20, :y=>100, :padding_left=>10, :padding_top=>10, :relative=>true)
		modal.add TextField.new("A - left", :x=>20, :y=>130, :padding_left=>10, :padding_top=>10, :relative=>true)
		modal.add TextField.new("D - right", :x=>20, :y=>160, :padding_left=>10, :padding_top=>10, :relative=>true)

		modal.add TextField.new("ESC - menu", :x=>170, :y=>70, :padding_left=>10, :padding_top=>10, :relative=>true)
		
		ok_butt = Button.new("OK", :x=>180, :y=>180, :padding_left=>20, :padding_top=>20,:relative=>true)
		ok_butt.on :pressed do |*opts|
			modal.close
		end
		
		modal.add ok_butt
		
		modal.display
	end
		
	modal_button2 = Button.new "Story of the trippy dino", :x=>70, :y=>320, :padding_left=>20, :padding_top=>20
	modal_button2.on :pressed do |*opts|
		modal = Dialog.new :modal => app, :x=>400, :y=>110, :w=>600, :h=>300
		
		modal.add Label.new("The story: ", :x=>20, :y=>10, :padding_left=>10, :padding_top=>10, :relative=>true)
		modal.add TextField.new("One upon a time, there was this little dino.", :x=>20, :y=>70, :padding_left=>10, :padding_top=>10, :relative=>true)
		modal.add TextField.new("His name was Fred. He was very curious so he took LSD.", :x=>20, :y=>100, :padding_left=>10, :padding_top=>10, :relative=>true)
		modal.add TextField.new("Join him in his journey for survival.", :x=>20, :y=>130, :padding_left=>10, :padding_top=>10, :relative=>true)
		modal.add TextField.new("This is .. the Trippy Dino.", :x=>20, :y=>160, :padding_left=>10, :padding_top=>10, :relative=>true)
			
		ok_butt = Button.new("OK", :x=>400, :y=>230, :padding_left=>20, :padding_top=>20,:relative=>true)
		
		ok_butt.on :pressed do |*opts|
			modal.close
		end
		
		modal.add ok_butt
		modal.display
	end
	
	modal_button3 = Button.new "Highscore", :x=>70, :y=>400, :padding_left=>20, :padding_top=>20
	modal_button3.on :pressed do |*opts|
		modal = Dialog.new :modal => app, :x=>400, :y=>110, :w=>600, :h=>300
		
		level_zero = TextField.new("  No highscore yet", :x=>50, :y=>160, :padding_left=>20, :padding_top=>5, :relative=>true)
		achievements_zero = TextField.new("No Achievements Gained", :x=>330, :y=>70, :padding_left=>10, :relative=>true)
		level_field = ''
		achievement_field1 = ''
		achievement_field2 = ''
		achievement_field3 = ''
		
		ok_butt = Button.new("OK", :x=>400, :y=>230, :padding_left=>20, :padding_top=>20,:relative=>true)
		reset_butt = Button.new("Reset", :x=>250, :y=>230, :padding_left=>20, :padding_top=>20,:relative=>true)
		
		modal.add TextField.new("Achievements:", :x=>350, :y=>30, :padding_left=>10, :relative=>true)
		modal.add TextField.new("Max level reached:", :x=>20, :y=>70, :padding_left=>10, :relative=>true)
		
		i = 0
		if File.exist?('highscore.csv')
			CSV.foreach('highscore.csv') do |row|
				level_field = TextField.new("  " + row.inspect.tr('[]""', ''), :x=>50, :y=>160, :padding_left=>20, :padding_top=>5, :relative=>true)
				achievement_field1 = TextField.new(row.inspect.tr('[]""', ''), :x=>330, :y=>70, :padding_left=>10, :relative=>true)
				achievement_field2 = TextField.new(row.inspect.tr('[]""', ''), :x=>330, :y=>110, :padding_left=>10, :relative=>true)
				achievement_field3 = TextField.new(row.inspect.tr('[]""', ''), :x=>330, :y=>150, :padding_left=>10, :relative=>true)
				
				case i
					when 0
						modal.add level_field
					when 1
						modal.add achievement_field1
					when 2
						modal.add achievement_field2
					when 3
						modal.add achievement_field3
				end
				
				i = i + 1
			end
		else
			modal.add level_zero
			modal.add achievements_zero
		end
		
		ok_butt.on :pressed do |*opts|
			modal.close
		end
		
		reset_butt.on :pressed do |*opts|
			if File.exist?('highscore.csv')
				File.delete('highscore.csv')
				
				achievement_field2.hide
				achievement_field1.hide
				achievement_field3.hide
				level_field.hide
				modal.add level_zero
				modal.add achievements_zero
			end
		end
		
		modal.add ok_butt, reset_butt
		modal.display
	end
	
	modal_button4 = Button.new "Saves", :x=>225, :y=>400, :padding_left=>20, :padding_top=>20
	modal_button4.on :pressed do |*opts|
		modal = Dialog.new :modal => app, :x=>400, :y=>110, :w=>600, :h=>300
		
		modal.add Label.new("Saves: ", :x=>20, :y=>10, :padding_left=>10, :padding_top=>10, :relative=>true)
		
		save_butt1 = Button.new("Save 1", :x=>70, :y=>70, :padding_left=>10, :padding_top=>10, :relative=>true)
		save_butt2 = Button.new("Save 2", :x=>70, :y=>125, :padding_left=>10, :padding_top=>10, :relative=>true)
		save_butt3 = Button.new("Save 3", :x=>70, :y=>180, :padding_left=>10, :padding_top=>10, :relative=>true)
		
		find_empty_save save_butt1, save_butt2, save_butt3, 1
		
		ok_butt = Button.new("OK", :x=>400, :y=>230, :padding_left=>20, :padding_top=>20, :relative=>true)
		
		save_butt = Button.new("Save Current", :x=>200, :y=>230, :padding_left=>20, :padding_top=>20,:relative=>true)
		
		ok_butt.on :pressed do |*opts|
			modal.close
		end
		
		shown_trigger = 0
		
		save_butt1.on :pressed do |*opts|
			shown_trigger = show_save_content 1, modal, save_butt1, shown_trigger
		end
		
		save_butt2.on :pressed do |*opts|
			shown_trigger = show_save_content 2, modal, save_butt2, shown_trigger
		end
		
		save_butt3.on :pressed do |*opts|
			shown_trigger = show_save_content 3, modal, save_butt3, shown_trigger
		end
		
		info_modal = Dialog.new :modal => app, :x=>400, :y=>110, :w=>600, :h=>300
		info_ok_butt = Button.new("OK", :x=>290, :y=>180, :padding_left=>10, :padding_top=>10, :relative=>true)
		info_modal.add Label.new("Saves Maximum Reached ", :x=>170, :y=>100, :padding_left=>20, :padding_top=>20, :relative=>true)
		
		info_ok_butt.on :pressed do |*opts|
			info_modal.close
			info_modal.hide
		end
		
		info_modal.add info_ok_butt
		
		save_butt.on :pressed do |*opts|
			params = [@eye.speed,
					@pac.speed,
					@clock.target_framerate,
					@jump_blocker,
					@presses,
					@level_count,
					@gained_achievements,
					@dir_left,
					@dir_right,
					@dir_up,
					@right_first_it,
					@left_first_it,
					@up_first_it]
			
			i = find_empty_save save_butt1, save_butt2, save_butt3
				
			if i == 1337
				modal.add info_modal
				info_modal.show
				info_modal.display
			else
				write_csv ('save' + i.to_s + '.csv'), params
			end
		end
		
		modal.add ok_butt, save_butt1, save_butt3, save_butt2, save_butt
		modal.display
	end
    
    app.add @button, modal_button, modal_button_settings, modal_button2, modal_button3, modal_button4
    
    app
  end
end
