require 'rubygems'
require 'rubygame'
require 'rubygoo'
require 'rubytrackselector'
require 'csv'
require '../source/gui.rb'
require '../source/player.rb'
require '../source/enemy.rb'
require '../source/dinozavurcheto.rb'

include Rubygame
include Rubygoo
include CreateGui
include Sprites::Sprite

describe Enemy do
	describe "#reset" do
		it "returns 0 if enemy position params are out of range, else nothing" do
			game = Game.new
			pac = Enemy.new 'pac'
			eye = Enemy.new 'eye'
			
			pac.reset.should eq(nil)
			pac.reset(1).should eq(0)
			pac.curr_x = -200
			pac.reset.should eq(0)
			pac.reset.should eq(nil)
			pac.curr_y = 900
			pac.reset.should eq(0)
			pac.reset.should eq(nil)
			
			eye.reset.should eq(nil)
			eye.reset(1).should eq(0)
			eye.curr_x = -200
			eye.reset.should eq(0)
			eye.reset.should eq(nil)
			eye.curr_y = 900
			eye.reset.should eq(0)
			eye.reset.should eq(nil)
		end
	end
	
	describe "#move" do
		it "returns 0 if enemy position params are out of range, else nothing" do
			game = Game.new
			pac = Enemy.new 'pac'
			eye = Enemy.new 'eye'
			
			pac.move.should eq(nil)
			pac.curr_x = -200
			pac.move.should eq(0)
			pac.move.should eq(nil)
			pac.curr_y = 900
			pac.move.should eq(0)
			pac.move.should eq(nil)
			
			eye.move.should eq(nil)
			eye.curr_x = -200
			eye.move.should eq(0)
			eye.move.should eq(nil)
			eye.curr_y = 900
			eye.move.should eq(0)
			eye.move.should eq(nil)
		end
	end
end
