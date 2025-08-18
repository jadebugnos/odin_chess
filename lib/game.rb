require_relative 'color_players/black_player'
require_relative 'color_players/white_player'
require_relative 'move_validator'
require_relative 'checkmate_finder'
require_relative 'game_messages'
require_relative 'utility'

# Represents the main Chess game loop and logic.
#
# Handles initialization, turn management, move validation,
# and win/loss conditions such as checkmate.
class ChessGame
  include MoveValidator
  include CheckmateFinder
  include Utility

  # @param board [ChessBoard] The board on which the game is played.
  def initialize(board)
    @board = board
    @player_one = nil
    @player_two = nil
    @first_to_move = nil
    @second_to_move = nil
    @current_player = nil
  end

  # Starts the game loop.
  #
  # @param state [Symbol, nil] :new to start a fresh game, otherwise resumes.
  # @return [void]
  def play_game(state = nil)
    loop do
      prepare_game(state)
      run_game
      break unless play_again?

      state = :restart
    end
  end

  # Prepares the game state before starting.
  #
  # Sets up the board, caches positions, and initializes players.
  #
  # @return [void]
  def prepare_game(state)
    return if state == :load

    slow_print(GameMessages.game_intro) unless state == :restart
    @board.set_up_pieces
    @board.cache_current_positions
    initialize_players unless same_players?(state)
  end

  # Initializes both players and assigns their names and colors.
  #
  # @return [void]
  def initialize_players
    @player_one = Player.new
    color = @player_one.handle_name_and_color
    @player_two = Player.new
    @player_two.handle_name_and_color(color)
  end

  # Runs the main game loop until checkmate occurs.
  #
  # @return [void]
  def run_game
    loop do
      @board.display_board
      handle_moves
      switch_turn
      break if its_checkmate?
    end
  end

  # Checks whether the current player's king is in checkmate.
  #
  # @return [Boolean] true if checkmate, false otherwise.
  def its_checkmate?
    color = @current_player.color
    board = @board.board
    king_pos = @board.get_king_position(color)

    return false unless checkmate?(color, board, king_pos)

    GameMessages.declare_checkmate

    true
  end

  # Manages turn order and executes player moves.
  #
  # @return [void]
  def handle_moves
    set_move_order if @first_to_move.nil?
    execute_moves
  end

  private

  # Executes moves for the current player until a valid move is made.
  #
  # @return [void]
  def execute_moves
    move = nil
    board = @board.board
    color = @current_player.color
    king_pos = @board.get_king_position(color)
    collector = {}

    loop do
      move = @current_player.validate_player_move(self)

      break if check_if_valid_move?(move, board, color, king_pos, collector)

      GameMessages.print_warning(collector)
    end

    @board.move_piece(move, board)
  end

  # Sets which player goes first based on color.
  #
  # White always moves first.
  #
  # @return [void]
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

  # Switches turn between players.
  #
  # @return [void]
  def switch_turn
    @current_player = @current_player == @first_to_move ? @second_to_move : @first_to_move
  end

  def play_again?
    puts 'Do you want to play again?(y/n)'
    handle_validation == 'y'
  end

  def same_players?(state)
    return false if state == :new

    puts 'Same_players?(y/n)'
    handle_validation == 'y'
  end
end
