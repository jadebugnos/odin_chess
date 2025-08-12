require_relative 'color_players/black_player'
require_relative 'color_players/white_player'
require_relative 'move_validator'
require_relative 'checkmate_finder'

# this file defines the ChessGame class which holds Game logic
class ChessGame
  include MoveValidator
  include CheckmateFinder

  def initialize(board)
    @board = board
    @player_one = nil
    @player_two = nil
    @first_to_move = nil
    @second_to_move = nil
    @current_player = nil
  end

  def play_game
    prepare_game
    run_game
  end

  # preparing game requirements before starting
  def prepare_game
    # slow_print(game_intro)
    @board.set_up_pieces
    @board.cache_current_positions
    initialize_players
  end

  # player initialization
  def initialize_players
    @player_one = Player.new
    color = @player_one.handle_name_and_color
    @player_two = Player.new
    @player_two.handle_name_and_color(color)
  end

  # main game loop
  def run_game
    loop do
      @board.display_board
      handle_moves
      switch_turn
      break if if_its_checkmate?
    end
  end

  def if_its_checkmate?
    color = @current_player.color
    board = @board.board
    king_pos = @board.get_king_position(color)

    checkmate?(color, board, king_pos)
  end

  # Manages turn order and executes player moves
  def handle_moves
    set_move_order if @first_to_move.nil?
    execute_moves
  end

  private

  # Loops until the player provides a valid move, then updates the board
  def execute_moves
    move = nil
    board = @board.board
    color = @current_player.color
    king_pos = @board.get_king_position(color)

    loop do
      move = @current_player.validate_player_move

      break if check_if_valid_move?(move, board, color, king_pos)
    end

    @board.move_piece(move, board)
  end

  # sets up players turn order
  def set_move_order
    if @player_one.color == :white
      @first_to_move = @player_one
      @second_to_move = @player_two
    else
      @first_to_move = @player_two
      @second_to_move = @player_one
    end

    @current_player = @first_to_move
  end

  def switch_turn
    @current_player = @current_player == @first_to_move ? @second_to_move : @first_to_move
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
