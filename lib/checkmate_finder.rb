module CheckmateFinder
  LINEAR_BLACK_PIECE = ['♜', '♛'].freeze # Rook, Queen
  LINEAR_WHITE_PIECE = ['♖', '♕'].freeze # Rook, Queen

  DIAGONAL_BLACK_PIECE = ['♝', '♛'].freeze # Bishop, Queen
  DIAGONAL_WHITE_PIECE = ['♗', '♕'].freeze # Bishop, Queen

  FIXED_BLACK_PIECE = ['♞', '♚', '♟'].freeze # Knight, King, Pawn
  FIXED_WHITE_PIECE = ['♘', '♔', '♙'].freeze # Knight, King, Pawn

  def checkmate?
    diagonal_search?
    linear_search?
    fixed_search?
  end

  # diagonally search from the POV of King piece. returns true
  # if the cell contains an enemy piece that captures with the same direction
  # otherwise returns false
  # parameters:
  # color - the current players color
  # board - A 2D array representing the Chessboard
  # start - the coordinates of the king piece
  # delta - the direction in which to search
  def diagonal_search?(color, board, start, delta)
    ally, enemy = handle_ally_foe(color, :diagonal)

    delta.any? do |delta|
      path_finder(start, delta, board) do |cell|
        return false if ally.include?(cell)
        return true if enemy.include?(cell)

        false
      end
    end
  end

  # private

  # dynamically returns ally and enemy pieces based on color and delta
  # - returns [ally_pieces_arr, enemy_pieces_arr]
  def handle_ally_foe(color, direction)
    pieces = {
      diagonal: { black: DIAGONAL_BLACK_PIECE, white: DIAGONAL_WHITE_PIECE },
      vertical: { black: LINEAR_BLACK_PIECE, white: LINEAR_WHITE_PIECE },
      fixed: { black: FIXED_BLACK_PIECE, white: FIXED_WHITE_PIECE }
    }

    ally_color = color
    enemy_color = color == :black ? :white : :black

    allies, all_enemies = color == :black ? [ALL_BLACK_PIECES, ALL_WHITE_PIECES] : [ALL_WHITE_PIECES, ALL_BLACK_PIECES]
    threats = DIRECTIONAL_PIECES[direction][enemy_color]
    friendly_enemies = all_enemies - threats

    [allies, threats, friendly_enemies]
  end

  # search in a straight line depending on the given direction
  def path_finder(start, delta, board)
    current_x = start[0] + delta[0]
    current_y = start[1] + delta[1]

    while inbound?(current_x, current_y)
      next_cell = board[current_x][current_y]

      result = yield(next_cell) if block_given?
      return result if [true, false].include?(result)

      current_x += delta[0]
      current_y += delta[1]
    end

    false
  end

  def inbound?(current_x, current_y)
    current_x.between?(0, 7) && current_y.between?(0, 7)
  end

  def get_delta(from, to)
    from <=> to
  end
end

DummyClass = Class.new do
  include CheckmateFinder
end

dummy = DummyClass.new
p dummy.handle_ally_foe(:black, :fixed)

