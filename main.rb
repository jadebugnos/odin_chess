require_relative 'lib/board'
require_relative 'lib/game'
require_relative 'lib/player'

# board = ChessBoard.new
# new_game = ChessGame.new(board)
# new_game.play_game

dummy_obj = Class.new do
  include Serializable
end.new

board = ChessBoard.new
game = ChessGame.new(board)

loaded = dummy_obj.handle_load_game

state = loaded ? :load : :new
(loaded || game).play_game(state)
