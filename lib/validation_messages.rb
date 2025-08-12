module ValidationMessages
  def self.invalid_format(input)
    puts "[Invalid] Input format is incorrect: #{input.inspect}"
  end

  def self.empty_source_cell(cell)
    puts "[Invalid] Source cell is empty: #{cell.inspect}"
  end

  def self.wrong_turn(cell, color)
    puts "[Invalid] Piece at #{cell} does not belong to #{color}"
  end

  def self.illegal_piece_move(cell)
    puts "[Invalid] Illegal move for piece at #{cell}"
  end

  def self.invalid_destination(cell)
    puts "[Invalid] Destination at #{cell} is not valid"
  end

  def self.king_is_in_check
    puts '[Invalid] Your king is in danger.'
  end
end
