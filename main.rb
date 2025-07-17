require_relative 'lib/board'
require_relative 'lib/game'
require_relative 'lib/player'

board = ChessBoard.new
new_game = ChessGame.new(board)
new_game.play_game
