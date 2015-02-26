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

describe Game do
	describe "#collision_check" do
		it "returns 1 if enemy position and player position are close, else 0" do
			game = Game.new
			player = Player.new
			eye = Enemy.new 'eye'
			pac = Enemy.new 'pac'
			
			game.collision_check(eye, player).should eq(0)
			player.curr_x = 100
			player.curr_y = 100
			eye.curr_x = 100
			eye.curr_y = 100
			game.collision_check(eye, player).should eq(1)
			eye.curr_x = 800
			game.collision_check(eye, player).should eq(0)
			eye.curr_x = 100
			eye.curr_y = 800
			game.collision_check(eye, player).should eq(0)
			eye.curr_y = 100
			player.curr_y = 800
			game.collision_check(eye, player).should eq(0)
			player.curr_y = 100
			player.curr_x = 800
			game.collision_check(eye, player).should eq(0)

			player.curr_x = 100
			player.curr_y = 100
			pac.curr_x = 100
			pac.curr_y = 100
			game.collision_check(pac, player).should eq(1)
			pac.curr_x = 800
			game.collision_check(pac, player).should eq(0)
			pac.curr_x = 100
			pac.curr_y = 800
			game.collision_check(pac, player).should eq(0)
			pac.curr_y = 100
			player.curr_y = 800
			game.collision_check(pac, player).should eq(0)
			player.curr_y = 100
			player.curr_x = 800
			game.collision_check(pac, player).should eq(0)
		end
	end
	
	describe "#achieve" do
		it "returns 1 if achievement gained, else returns nil,
			if passed through the same achievemnt for a second time returns true" do
			game = Game.new
			
			game.achieve.should eq(nil)
			game.dir_up = 73
			game.achieve.should eq(1)
			game.achieve.should eq(nil)
			game.dir_up = 42
			game.achieve.should eq(nil)
			game.dir_right = 25
			game.achieve.should eq(1)
			game.achieve.should eq(nil)
			game.dir_right = 42
			game.achieve.should eq(nil)
			game.dir_left = 50
			game.achieve.should eq(1)
			game.achieve.should eq(nil)
			game.dir_left = 42
			game.achieve.should eq(nil)
		end
	end
	
	describe "#write_csv" do
		it "return nil when file is done" do
			game = Game.new
			
			game.level_count = 42
			game.write_csv('highscore.csv', ["1", "2", "3"]).should eq(nil)
		end
	end
	
	describe "#parse_csv" do
		it "return nil when file is done" do
			game = Game.new
			
			game.parse_csv('highscore.csv', 1).should eq(["[\"Level 42\"]"])
			game.parse_csv('highscore.csv', 2).should eq(["[\"Level 42\"]", "[\"1\"]"])
			game.parse_csv('highscore.csv', 3).should eq(["[\"Level 42\"]", "[\"1\"]", "[\"2\"]"])
			game.parse_csv('highscore.csv', 4).should eq(["[\"Level 42\"]", "[\"1\"]", "[\"2\"]", "[\"3\"]"])
			game.parse_csv('highscore.csv', 5).should eq(["[\"Level 42\"]", "[\"1\"]", "[\"2\"]", "[\"3\"]"])
		end
	end
	
	describe "#set_highscore" do
		it "return nil when file is done" do
			game = Game.new
			
			game.set_highscore.should eq(nil)
			game.level_count = 48
			game.set_highscore.should eq(nil)
			File.delete('highscore.csv')
		end
	end
	
	describe "#update" do
		it "returns 1 if achievement gained, else returns nil,
			if passed through the same achievemnt for a second time returns true;
			if in the menu screen returns 0 || 1;
			if at end game returns 0" do
			
			game = Game.new
			
			game.change_view = 1
			game.update.should eq(nil)
			game.dir_up = 73
			game.update.should eq(1)
			game.update.should eq(nil)
			game.dir_up = 42
			game.update.should eq(nil)
			game.dir_right = 25
			game.update.should eq(1)
			game.update.should eq(nil)
			game.dir_right = 42
			game.update.should eq(nil)
			game.dir_left = 50
			game.update.should eq(1)
			game.update.should eq(nil)
			game.dir_left = 42
			game.update.should eq(nil)
			
			game.change_view = -1
			game.update.should eq(0)
			
			game.change_view = 0
			game.update.should eq(1)
			game.update.should eq(0)
		end
	end
	
end
