require 'rubygems'
require 'rubygame'
require 'rubygoo'
require 'rubytrackselector'
require 'csv'
require './gui.rb'
require './player.rb'
require './enemy.rb'
require './dinozavurcheto.rb'

include Rubygame
include Rubygoo
include CreateGui
include Sprites::Sprite

game = Game.new
game.run
