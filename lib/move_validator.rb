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
    check_input_format?(input) &&           # [ ] Is the input format like "e2"?
      empty_cell?(board, input) &&          # [ ] Does the source square have a piece?
      check_players_turn?(color, input) &&  # [ ] Is it the correct player's turn?
      check_piece_legal_move?(input) &&     # [ ] Is the move allowed by the piece type?
      check_clear_path?(input) &&           # [ ] Is the path clear (for sliding pieces)?
      check_destination_cell?(input)        # [ ] Is the destination valid (empty or enemy)?
  end

  def check_input_format?(input); end

  def empty_cell?(board, input); end

  def check_players_turn?(color, input); end

  def check_piece_legal_move?(input); end

  def check_clear_path?(input); end

  def check_destination_cell?(input); end
end
