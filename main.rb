require_relative 'lib/board'
require_relative 'lib/game'
require_relative 'lib/player'

player = Player.new
board = ChessBoard.new
new_game = ChessGame.new(player, board)
new_game.play_game
