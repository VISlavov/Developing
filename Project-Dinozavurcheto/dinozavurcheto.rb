#!/bin/env ruby

require 'rubygems'
require 'rubygame'
require 'rubygoo'
require './create_gui.rb'
require "rubytrackselector"

include Rubygame
include Rubygoo
include CreateGui

class Game
  def initialize
    @screen = Rubygame::Screen.new [880,480], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
    @screen.title = "Trippy dino"

    @queue = Rubygame::EventQueue.new
    @clock = Rubygame::Clock.new
    @clock.target_framerate = 30
    
    @first_iteration = 0
    @first_iteration_2 = 0
    
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
					end
		end
		
		@app_adapter.on_event ev
	end
	
	@app_adapter.update @clock.tick
	if @change_view == 1
		@background.blit @screen, [0, 0]
		if @first_iteration == 0 && @rts.tag != RTS::LOADING
			@rts.tag = RTS::ACTION_SCENE
			@rts.play(:repeats => 100000)
			@first_iteration = 1
		else
			@first_iteration_2 = 0
		end
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
