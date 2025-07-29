require_relative '../lib/positions'
require_relative '../lib/piece_index'
require_relative '../lib/validation_messages'

module MoveValidator
  # this will be a method wrapper for all move validation:
  # checklist of all the validations:
  # [x] Is the input in the correct format?
  # [x] Does the source square have a piece?
  # [x] Is it that player's turn?
  # [x] Is the move allowed by the piece type?
  # [x] Is the path clear (for sliding pieces)?
  # [x] Is the destination valid (empty or enemy)?
  # [ ] Does the move avoid putting own king in check?
  # [ ] Are castling/en passant/promotion rules followed if applicable?

  def check_if_valid_move?(input, board, color) # rubocop:disable Metrics/MethodLength
    unless check_input_format?(input)
      ValidationMessages.invalid_format(input)
      return false
    end

    unless occupied_source_cell?(board, input)
      ValidationMessages.empty_source_cell(input[0])
      return false
    end

    unless check_players_turn?(color, input, board)
      ValidationMessages.wrong_turn(input[0], color)
      return false
    end

    unless check_piece_legal_move?(color, input, board)
      ValidationMessages.illegal_piece_move(input[0])
      return false
    end

    unless empty_destination?(input, board, color)
      ValidationMessages.invalid_destination(input[1])
      return false
    end

    true
  end

  # checks if the input is in the correct format
  def check_input_format?(input)
    return false if input.include?(nil)

    input.flatten.all? { |item| item.between?(0, 7) }
  end

  # check the source cell since input is [[x, y] [x, y]] and the first
  # element is the source cell. will return false if cell is empty otherwise return true
  def occupied_source_cell?(board, input)
    x, y = input[0]

    return false if board[x][y] == ''

    true
  end

  # Checks if the piece being moved belongs to the current player
  def check_players_turn?(turn, input, board)
    x, y = input[0]
    icon = board[x][y]

    Positions::INITIAL_POSITIONS[turn].key?(icon)
  end

  # Delegates move validation to the piece's `legal_move?` method
  def check_piece_legal_move?(color, player_move, board)
    x, y = player_move[0]
    icon = board[x][y]

    PieceIndex::PIECE_HASH[color][icon].legal_move?(player_move, board, color)
  end

  # remind me: TDD this method next to add functionality
  # then add logic to #update_board in the Board class
  def empty_destination?(move, board, color)
    (from_x, from_y), (to_x, to_y) = move
    piece = board[to_x][to_y]
    pawn = board[from_x][from_y]

    return check_pawn_destination?(move, board, color, pawn) if piece_is_pawn?(pawn)

    generic_valid_destination?(piece, color)
  end

  # this method handles the destination validation for all pieces except the pawn
  def generic_valid_destination?(piece, color)
    ally, enemy = color == :black ? %i[black white] : %i[white black]

    contains_enemy = Positions::INITIAL_POSITIONS[enemy].key?(piece)
    contains_ally = Positions::INITIAL_POSITIONS[ally].key?(piece)

    return true if piece == '' || contains_enemy
    return false if contains_ally

    false
  end

  private

  def check_pawn_destination?(move, board, color, pawn)
    PieceIndex::PIECE_HASH[color][pawn].pawn_valid_destination?(move, board, color)
  end

  def piece_is_pawn?(piece)
    ["\u2659", "\u265F"].include?(piece)
  end
end
