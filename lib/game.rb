# this file defines the ChessGame class which holds Game logic
class ChessGame
  def initialize(player, board)
    @player = player
    @board = board
  end

  def play_game
    slow_print(game_intro)
    @board.set_up_pieces
    run_game
  end

  def run_game
    loop do
      @board.display_board
      handle_moves
    end
  end

  def handle_moves
    @player.validate_player_move
  end

  def game_intro
    <<~INTRO
      ♔♕♖♗♘♙  Welcome to Ruby Chess  ♟♞♝♜♛♚

      Two armies face off on the 8x8 battlefield.
      Your goal: Checkmate your opponent’s king.

      Each piece moves in unique patterns — strategy, patience,
      and foresight will lead you to victory.

      May your moves be bold and your tactics sharp!

      Let the game begin...

    INTRO
  end

  def slow_print(text)
    text.each_char do |char|
      print char
      sleep(0.03)
    end
    puts
  end
end
