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

describe Player do
	describe "#reset" do
		it "returns background if in range, else 1337" do
			game = Game.new
			player = Player.new
			player.reset(42).should eq(42)
			player.reset(42, 1).should eq(1337)
			player.curr_x = 2000
			player.reset(42, 0).should eq(1337)
			player.reset(42, 0).should eq(42)
		end
	end
	
	describe "#change_frame" do
		it "changes the current image" do
			game = Game.new
			player = Player.new
			player.change_frame('d', 1).should eq(player.image6)
			player.change_frame('a', 1).should eq(player.image5)
			player.change_frame('as', 1).should eq(0)
			player.change_frame(42, 1).should eq(0)
			player.change_frame('d', 0).should eq(player.image1)
			player.change_frame('d', 0).should eq(player.image2)
			player.change_frame('d', 0).should eq(player.image1)
			player.change_frame('d', 0).should eq(player.image2)
			player.change_frame('a', 0).should eq(player.image3)
			player.change_frame('a', 0).should eq(player.image4)
			player.change_frame('a', 0).should eq(player.image3)
			player.change_frame('a', 0).should eq(player.image4)
			player.change_frame('d', 0).should eq(player.image1)
			player.change_frame('d', 0).should eq(player.image2)
			player.change_frame('d', 0).should eq(player.image1)
			player.change_frame('d', 0).should eq(player.image2)
			player.change_frame('afasf', 0).should eq(0)
			player.change_frame(12124, 0).should eq(0)
			player.change_frame('d', 1).should eq(player.image6)
			player.change_frame('a', 1).should eq(player.image5)
		end
	end
	
	describe "#jump" do
		it "player stats should change their evaluation" do
			game = Game.new
			player = Player.new
			player.jump_ascending = 1
			player.jump.should eq(340)
			player.jump.should eq(330)
			player.jump.should eq(320)
			player.jump_ascending = -1
			player.jump.should eq(330)
			player.jump.should eq(340)
			player.jump.should eq(350)
		end
	end
	
	describe "#move" do
		it "player stats should change their evaluation" do
			game = Game.new
			player = Player.new
			player.move('w', 42).should eq(42)
			player.move('d', 42).should eq(42)
			player.move('a', 42).should eq(42)
			player.move(1337, 42).should eq(42)
			player.move(42, 42).should eq(42)
			player.move('afasfaf', 42).should eq(42)
			player.move(12414, 42).should eq(42)
			player.curr_x = 3000
			player.move('w', 42).should eq(1337)
			player.move('w', 42).should eq(42)
			player.curr_x = 3000
			player.move('d', 42).should eq(1337)
			player.move('d', 42).should eq(42)
			player.curr_x = 3000
			player.move('a', 42).should eq(1337)
			player.move('a', 42).should eq(42)
			player.curr_x = 3000
			player.move(1337, 42).should eq(1337)
			player.move(1337, 42).should eq(42)
			player.curr_x = 3000
			player.move(42, 42).should eq(1337)
			player.move(42, 42).should eq(42)
			player.curr_x = 3000
			player.move('afasfaf', 42).should eq(1337)
			player.move('afasfaf', 42).should eq(42)
			player.curr_x = 3000
			player.move(12414, 42).should eq(1337)
			player.move(12414, 42).should eq(42)
		end
	end
end
