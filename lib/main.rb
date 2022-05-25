require 'yaml'
require './game.rb'

$game =  Game.new()
puts $game
$game.directions()
$game.round()



