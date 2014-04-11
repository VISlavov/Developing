module CreateGui
  def create_gui renderer, music, screen
    app = App.new :renderer => renderer
	
	@change_view = 0

	@button = Button.new "Start/Continue game", :x=>70, :y=>80, :w=>200, :h=>100, :padding_left=>20, :padding_top=>20
	
	@button.on :pressed do |*opts|
		@change_view = 1
	end

    grp1 = RadioGroup.new :x=>200, :y=>190, :padding_left=>20, :padding_top=>20, :w=> 170, :h=>100

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
		
	grp1.hide

    hide_button = Button.new "Settings", :x=>70, :y=>240, :padding_left=>20, :padding_top=>20
    hide_button.on :pressed do |*opts|
      if grp1.visible?
        grp1.hide
      else
        grp1.show
      end
    end
    
    modal_button = Button.new "Help", :x=>70, :y=>160, :padding_left=>20, :padding_top=>20
	modal_button.on :pressed do |*opts|
		puts 1
		
		modal = Dialog.new :modal => app, :x=>400, :y=>110, :w=>350, :h=>250

		modal.add Label.new("Controls: ", :x=>20, :y=>10, :padding_left=>10, :padding_top=>10, :relative=>true)
		modal.add TextField.new("W - up", :x=>20, :y=>70, :padding_left=>10, :padding_top=>10, :relative=>true)
		modal.add TextField.new("S - down", :x=>20, :y=>100, :padding_left=>10, :padding_top=>10, :relative=>true)
		modal.add TextField.new("A - left", :x=>20, :y=>130, :padding_left=>10, :padding_top=>10, :relative=>true)
		modal.add TextField.new("D - right", :x=>20, :y=>160, :padding_left=>10, :padding_top=>10, :relative=>true)
		
		ok_butt = Button.new("OK", :x=>180, :y=>180, :padding_left=>20, :padding_top=>20,:relative=>true)
		ok_butt.on :pressed do |*opts|
			modal.close
		end
		
		modal.add ok_butt
		
		modal.display
	end
		
	modal_button2 = Button.new "Story of the trippy dino", :x=>70, :y=>320, :padding_left=>20, :padding_top=>20
	modal_button2.on :pressed do |*opts|
		modal2 = Dialog.new :modal => app, :x=>400, :y=>110, :w=>350, :h=>250
			
		ok_butt2 = Button.new("OK", :x=>180, :y=>180, :padding_left=>20, :padding_top=>20,:relative=>true)
		
		ok_butt2.on :pressed do |*opts|
			modal2.close
		end
		
		modal2.add ok_butt2
		
		modal2.display
	end
    
    app.add @button, modal_button, grp1, hide_button, modal_button2

    app
  end
end
