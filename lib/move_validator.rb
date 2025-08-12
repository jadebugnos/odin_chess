require_relative '../lib/positions'
require_relative '../lib/piece_index'
require_relative '../lib/validation_messages'
require_relative '../lib/check_finder'

module MoveValidator
  include CheckFinder

  # def check_if_valid_move?(input, board, color, king_pos)
  #   unless check_input_format?(input)
  #     ValidationMessages.invalid_format(input)
  #     return false
  #   end

  #   unless occupied_source_cell?(board, input)
  #     ValidationMessages.empty_source_cell(input[0])
  #     return false
  #   end

  #   unless check_players_turn?(color, input, board)
  #     ValidationMessages.wrong_turn(input[0], color)
  #     return false
  #   end

  #   unless check_piece_legal_move?(color, input, board)
  #     ValidationMessages.illegal_piece_move(input[0])
  #     return false
  #   end

  #   unless empty_destination?(input, board, color)
  #     ValidationMessages.invalid_destination(input[1])
  #     return false
  #   end

  #   unless check_king_safety?(color, board, input, king_pos)
  #     ValidationMessages.king_is_in_check
  #     return false
  #   end

  #   true
  # end

  # this will be a method wrapper for all move validation:
  # checklist of all the validations:
  # [x] Is the input in the correct format?
  # [x] Does the source square have a piece?
  # [x] Is it that player's turn?
  # [x] Is the move allowed by the piece type?
  # [x] Is the path clear (for sliding pieces)?
  # [x] Is the destination valid (empty or enemy)?
  # [x] Does the move avoid putting own king in check?
  # [ ] Are castling/en passant/promotion rules followed if applicable?
  def check_if_valid_move?(input, board, color, king_pos, collector = nil)
    check_input_format?(input, collector) &&
      occupied_source_cell?(board, input, collector) &&
      check_players_turn?(color, input, board, collector) &&
      check_piece_legal_move?(color, input, board, collector) &&
      empty_destination?(input, board, color, collector) &&
      check_king_safety?(color, board, input, king_pos, collector)
  end

  # checks if the input is in the correct format
  # @param input [Array<Array>] a 2D array of origin and target coordinates [[fx, fy], [tx, ty]]
  # @param collector [Hash] optional storage for result for later use
  def check_input_format?(input, collector = nil)
    return false if input.include?(nil)

    result = input.flatten.all? { |item| item.between?(0, 7) }

    collector[:input_format] = result unless collector.nil?

    result
  end

  # check the source cell since input is [[x, y] [x, y]] and the first
  # element is the source cell. will return false if cell is empty otherwise return true
  def occupied_source_cell?(board, input, collector = nil)
    x, y = input[0]

    result = board[x][y] != ''

    collector[:occupied_source_cell] = result unless collector.nil?

    result
  end

  # Checks if the piece being moved belongs to the current player
  def check_players_turn?(turn, input, board, collector = nil)
    x, y = input[0]
    icon = board[x][y]

    result = Positions::INITIAL_POSITIONS[turn].key?(icon)

    collector[:players_turn] = result unless collector.nil?

    result
  end

  # Delegates move validation to the piece's `legal_move?` method
  def check_piece_legal_move?(color, player_move, board, collector = nil)
    x, y = player_move[0]
    icon = board[x][y]

    result = PieceIndex::PIECE_HASH[color][icon].legal_move?(player_move, board, color)

    collector[:piece_legal_move] = result unless collector.nil?

    result
  end

  # remind me: TDD this method next to add functionality
  # then add logic to #update_board in the Board class
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

  def check_king_safety?(color, board, move, king_pos, collector = nil)
    board_duplicate = deep_copy_board(board)
    execute_move(move, board_duplicate)

    result = !check_found?(color, board_duplicate, king_pos)

    collector[:king_safety] = result unless collector.nil?

    result
  end

  private

  # this method handles the destination validation for all pieces except the pawn
  def generic_valid_destination?(piece, color)
    ally, enemy = color == :black ? %i[black white] : %i[white black]

    contains_enemy = Positions::INITIAL_POSITIONS[enemy].key?(piece)
    contains_ally = Positions::INITIAL_POSITIONS[ally].key?(piece)

    return true if piece == '' || contains_enemy
    return false if contains_ally

    false
  end

  def execute_move(move, board)
    (from_x, from_y), (to_x, to_y) = move

    icon = board[from_x][from_y]
    board[from_x][from_y] = ''
    board[to_x][to_y] = icon
  end

  def deep_copy_board(board)
    board.map { |row| row.map(&:dup) }
  end

  def check_pawn_destination?(move, board, color, pawn)
    PieceIndex::PIECE_HASH[color][pawn].pawn_valid_destination?(move, board, color)
  end

  def piece_is_pawn?(piece)
    ["\u2659", "\u265F"].include?(piece)
  end
end
