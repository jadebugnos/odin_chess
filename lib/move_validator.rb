require_relative '../lib/positions'
require_relative '../lib/piece_index'

module MoveValidator
  # this will be a method wrapper for all move validation:
  # checklist of all the validations:
  # [ ] Is the input in the correct format? (e.g., "e2", "g5")
  # [ ] Does the source square have a piece?
  # [ ] Is it that player's turn?
  # [ ] Is the move allowed by the piece type?
  # [ ] Is the path clear (for sliding pieces)?
  # [ ] Is the destination valid (empty or enemy)?
  # [ ] Does the move avoid putting own king in check?
  # [ ] Are castling/en passant/promotion rules followed if applicable?

  def check_if_valid_move?(input, board, color)
    check_input_format?(input) &&            # [ ] Is the input format like "e2"?
      occupied_source_cell?(board, input) && # [ ] Does the source square have a piece?
      check_players_turn?(turn, input, board) && # [ ] Is it the correct player's turn?
      check_piece_legal_move?(color, input, board) # [ ] Is the move allowed by the piece type?
    # empty_destination_cell?(input)
  end

  # checks if the input is in the correct format (e.g., "e2", "g5")
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

  def check_players_turn?(turn, input, board)
    x, y = input[0]
    icon = board[x][y]

    Positions::INITIAL_POSITIONS[turn].key?(icon)
  end

  def check_piece_legal_move?(color, player_move, board)
    x, y = player_move[0]
    icon = board[x][y]

    PieceIndex::PIECE_HASH[color][icon].legal_move?(player_move, board, color)
  end

  def empty_destination_cell?(input); end
end
