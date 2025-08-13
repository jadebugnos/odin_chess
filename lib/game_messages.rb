module ValidationMessages
  MESSAGES = {
    input_format: '[Invalid] Incorrect input format.',
    occupied_source_cell: '[Invalid] No piece at the source cell.',
    players_turn: '[Invalid] Not your turn.',
    piece_legal_move: '[Invalid] Illegal move for this piece.',
    empty_destination: '[Invalid] Destination cell is empty.',
    king_safety: '[Invalid] Move would place or leave your king in check.'
  }.freeze

  def self.print_warning(results)
    failed_validation = results.key(false)

    puts MESSAGES[failed_validation]
  end
end
