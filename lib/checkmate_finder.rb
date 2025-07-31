module CheckmateFinder
  LINEAR_BLACK_PIECE = ['♜', '♛'].freeze # Rook, Queen
  LINEAR_WHITE_PIECE = ['♖', '♕'].freeze # Rook, Queen

  DIAGONAL_BLACK_PIECE = ['♝', '♛'].freeze # Bishop, Queen
  DIAGONAL_WHITE_PIECE = ['♗', '♕'].freeze # Bishop, Queen

  FIXED_BLACK_PIECE = ['♞', '♚', '♟'].freeze # Knight, King, Pawn
  FIXED_WHITE_PIECE = ['♘', '♔', '♙'].freeze # Knight, King, Pawn

  ALL_BLACK_PIECES = ['♟', '♜', '♝', '♞', '♛', '♚'].freeze
  ALL_WHITE_PIECES = ['♙', '♖', '♗', '♘', '♕', '♔'].freeze

  DIRECTIONAL_PIECES = {
    diagonal: { black: ['♝', '♛'], white: ['♗', '♕'] },
    linear: { black: ['♜', '♛'], white: ['♖', '♕'] },
    fixed: { black: ['♞', '♟'], white: ['♘', '♙'] }
  }.freeze

  def checkmate?
    diagonal_search?
    linear_search?
    fixed_search?
  end

  # search based of a given delta from the POV of King piece. returns true
  # if the cell contains an enemy piece that captures with the same direction
  # otherwise returns false
  # parameters:
  # color - the current players color
  # board - A 2D array representing the Chessboard
  # start - the coordinates of the king piece
  # delta - the directions in which to search
  def directional_search?(color, board, start, delta, direction)
    ally, enemy, friendly_enemies = identify_threats_and_allies(color, direction)

    delta.any? do |delta|
      path_finder(start, delta, board) do |cell|
        next false if ally.include?(cell)
        next false if friendly_enemies.include?(cell)
        return true if enemy.include?(cell)
      end
    end
  end

  def diagonal_search?; end

  def linear_search?; end

  def fixed_search?; end

  # private

  # dynamically sort and returns ally, enemy pieces and threats based on color and delta
  def identify_threats_and_allies(color, direction)
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

# DummyClass = Class.new do
#   include CheckmateFinder
# end
