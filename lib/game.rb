require_relative 'color_players/black_player'
require_relative 'color_players/white_player'

# this file defines the ChessGame class which holds Game logic
class ChessGame
  def initialize(player, board)
    @player = player
    @board = board
    @player_one = nil
    @player_two = nil
  end

  def play_game
    prepare_game
    run_game
  end

  def prepare_game
    slow_print(game_intro)
    @board.set_up_pieces
    set_up_player_infos
  end

  # fix me: allow black and white players to choose(use black and white child objects
  # instead of the Player parent class)
  def set_up_player_infos
    @player_one = Player.new
    color = @player_one.handle_name_and_color
    @player_two = Player.new
    @player_two.handle_name_and_color(color)
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
