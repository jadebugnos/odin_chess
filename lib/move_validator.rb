require_relative '../lib/positions'
require_relative '../lib/piece_index'
require_relative '../lib/game_messages'
require_relative '../lib/check_finder'

module MoveValidator
  include CheckFinder

  # Validates whether a player's move is legal based on a checklist:
  # - Input format is valid
  # - Source cell contains a piece
  # - The piece belongs to the current player
  # - Move is legal for that piece
  # - Destination is valid (empty or enemy)
  # - Move does not leave own king in check
  #
  # @param input [Array<Array>] move coordinates [[from_x, from_y], [to_x, to_y]]
  # @param board [Array<Array>] 2D array representing the board
  # @param color [Symbol] the current player's color (:white or :black)
  # @param king_pos [Array<Integer>] current king's position [x, y]
  # @param collector [Hash, nil] optional tracker storing which rule failed
  # @return [Boolean] true if the move is valid, false otherwise
  def check_if_valid_move?(input, board, color, king_pos, collector = nil)
    check_input_format?(input, collector) &&
      occupied_source_cell?(board, input, collector) &&
      check_players_turn?(color, input, board, collector) &&
      check_piece_legal_move?(color, input, board, collector) &&
      empty_destination?(input, board, color, collector) &&
      check_king_safety?(color, board, input, king_pos, collector)
  end

  # Checks if the input move is within valid board coordinates.
  #
  # @param input [Array<Array>] move coordinates [[from_x, from_y], [to_x, to_y]]
  # @param collector [Hash, nil] tracker to record failure if invalid
  # @return [Boolean] true if format is valid, false otherwise
  def check_input_format?(input, collector = nil)
    return false if input.include?(nil)

    result = input.flatten.all? { |item| item.between?(0, 7) }

    collector[:input_format] = result unless collector.nil?

    result
  end

  # Checks if the source cell contains a piece.
  #
  # @param board [Array<Array>] 2D board array
  # @param input [Array<Array>] move coordinates
  # @param collector [Hash, nil] tracker to record failure if empty
  # @return [Boolean] true if source cell has a piece, false otherwise
  def occupied_source_cell?(board, input, collector = nil)
    x, y = input[0]

    result = board[x][y] != ''

    collector[:occupied_source_cell] = result unless collector.nil?

    result
  end

  # Checks if the selected piece belongs to the current player.
  #
  # @param turn [Symbol] current player's color (:white or :black)
  # @param input [Array<Array>] move coordinates
  # @param board [Array<Array>] 2D board array
  # @param collector [Hash, nil] tracker to record failure if wrong player
  # @return [Boolean] true if piece matches player's turn, false otherwise
  def check_players_turn?(turn, input, board, collector = nil)
    x, y = input[0]
    icon = board[x][y]

    result = Positions::INITIAL_POSITIONS[turn].key?(icon)

    collector[:players_turn] = result unless collector.nil?

    result
  end

  # Validates that the piece's movement follows its rules.
  #
  # @param color [Symbol] current player's color
  # @param player_move [Array<Array>] move coordinates
  # @param board [Array<Array>] 2D board array
  # @param collector [Hash, nil] tracker to record failure if illegal move
  # @return [Boolean] true if move is legal for that piece, false otherwise
  def check_piece_legal_move?(color, player_move, board, collector = nil)
    x, y = player_move[0]
    icon = board[x][y]

    result = PieceIndex::PIECE_HASH[color][icon].legal_move?(player_move, board, color)

    collector[:piece_legal_move] = result unless collector.nil?

    result
  end

  # Validates the destination square of a move:
  # - Pawn: checks with pawn-specific rules
  # - Others: ensures square is empty or occupied by an enemy
  #
  # @param move [Array<Array>] move coordinates
  # @param board [Array<Array>] 2D board array
  # @param color [Symbol] current player's color
  # @param collector [Hash, nil] tracker to record failure if invalid
  # @return [Boolean] true if destination is valid, false otherwise
  def empty_destination?(move, board, color, collector = nil)
    (from_x, from_y), (to_x, to_y) = move
    piece = board[to_x][to_y]
    pawn = board[from_x][from_y]

    result = if piece_is_pawn?(pawn)
               check_pawn_destination?(move, board, color, pawn)
             else
               generic_valid_destination?(piece, color)
             end

    collector[:empty_destination] = result unless collector.nil?

    result
  end

  # Checks if the move would put or leave the king in check.
  #
  # @param color [Symbol] current player's color
  # @param board [Array<Array>] 2D board array
  # @param move [Array<Array>] move coordinates
  # @param king_pos [Array<Integer>] current king's position
  # @param collector [Hash, nil] tracker to record failure if unsafe
  # @return [Boolean] true if king is safe after move, false otherwise
  def check_king_safety?(color, board, move, king_pos, collector = nil)
    board_duplicate = deep_copy_board(board)
    execute_move(move, board_duplicate)

    result = !check_found?(color, board_duplicate, king_pos)

    collector[:king_safety] = result unless collector.nil?

    result
  end

  private

  # Validates destination for non-pawn pieces.
  #
  # @param piece [String] the piece at the target cell
  # @param color [Symbol] current player's color
  # @return [Boolean] true if target is empty or enemy, false otherwise
  def generic_valid_destination?(piece, color)
    ally, enemy = color == :black ? %i[black white] : %i[white black]

    contains_enemy = Positions::INITIAL_POSITIONS[enemy].key?(piece)
    contains_ally = Positions::INITIAL_POSITIONS[ally].key?(piece)

    return true if piece == '' || contains_enemy
    return false if contains_ally

    false
  end

  # Executes a move on a duplicate board (used for safety checks).
  #
  # @param move [Array<Array>] move coordinates
  # @param board [Array<Array>] 2D board array
  # @return [void]
  def execute_move(move, board)
    (from_x, from_y), (to_x, to_y) = move

    icon = board[from_x][from_y]
    board[from_x][from_y] = ''
    board[to_x][to_y] = icon
  end

  # Creates a deep copy of the board to test hypothetical moves safely.
  #
  # @param board [Array<Array>] 2D board array
  # @return [Array<Array>] duplicated board
  def deep_copy_board(board)
    board.map { |row| row.map(&:dup) }
  end

  # Validates pawn-specific move destinations.
  #
  # @param move [Array<Array>] move coordinates
  # @param board [Array<Array>] 2D board array
  # @param color [Symbol] current player's color
  # @param pawn [String] pawn character
  # @return [Boolean] true if pawn destination is valid, false otherwise
  def check_pawn_destination?(move, board, color, pawn)
    PieceIndex::PIECE_HASH[color][pawn].pawn_valid_destination?(move, board, color)
  end

  # Checks if the piece is a pawn (white or black).
  #
  # @param piece [String] Unicode character of the piece
  # @return [Boolean] true if piece is a pawn, false otherwise
  def piece_is_pawn?(piece)
    ["\u2659", "\u265F"].include?(piece)
  end
end
