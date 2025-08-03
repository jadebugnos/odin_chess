require_relative 'check_constants'

module CheckFinder
  include CheckConstants

  def check_found?(color, board, king_position)
    diagonal_search?(color, board, king_position) ||
      linear_search?(color, board, king_position) ||
      knight_search?(color, board, king_position) ||
      pawn_search?(color, board, king_position) ||
      king_search?(color, board, king_position)
  end

  # search based of a given delta from the POV of King piece. returns true
  # if the cell contains an enemy piece that captures with the same direction
  # otherwise returns false
  # parameters:
  # color - the current players color
  # board - A 2D array representing the Chessboard
  # start - the coordinates of the king piece
  # delta - the directions in which to search
  def directional_search?(color, board, start, deltas, direction)
    ally, enemy, friendly_enemies = identify_threats_and_allies(color, direction)

    deltas.any? do |delta|
      straight_path_traversal(start, delta, board) do |cell|
        next false if ally.include?(cell)
        next false if friendly_enemies.include?(cell)
        return true if enemy.include?(cell)
      end
    end
  end

  def diagonal_search?(color, board, king_position)
    directional_search?(color, board, king_position, DIAGONAL_DELTAS, :diagonal)
  end

  def linear_search?(color, board, king_position)
    directional_search?(color, board, king_position, LINEAR_DELTAS, :linear)
  end

  def knight_search?(color, board, king_position)
    fixed_search?(color, board, king_position, KNIGHT_DELTAS, :leaper)
  end

  def pawn_search?(color, board, king_position)
    enemy_color = color == :black ? :white : :black
    pawn_deltas = PAWN_DELTAS[enemy_color]
    fixed_search?(color, board, king_position, pawn_deltas, :stepper)
  end

  def king_search?(color, board, king_position)
    fixed_search?(color, board, king_position, KING_DELTAS, :royal)
  end

  def fixed_search?(color, board, king_pos, deltas, direction)
    ally, enemy, friendly_enemies = identify_threats_and_allies(color, direction)

    fixed_path_traversal(board, king_pos, deltas) do |cell|
      next false if ally.include?(cell) || friendly_enemies.include?(cell)

      enemy.include?(cell)
    end
  end

  # From the king's point of view, check surrounding squares based on fixed deltas
  # to detect immediate threats (e.g., knights, pawns, king)
  def fixed_path_traversal(board, king_position, deltas)
    deltas.any? do |dx, dy|
      current_x = king_position[0] + dx
      current_y = king_position[1] + dy

      next false unless inbound?(current_x, current_y)

      current_position = board[current_x][current_y]

      yield(current_position) if block_given?
    end
  end

  # private

  # Given a color and piece type (direction), returns:
  # - allied pieces
  # - enemy pieces that threaten in this direction
  # - enemy pieces that do not threaten in this direction
  def identify_threats_and_allies(color, direction)
    enemy_color = color == :black ? :white : :black

    allies, all_enemies = color == :black ? [ALL_BLACK_PIECES, ALL_WHITE_PIECES] : [ALL_WHITE_PIECES, ALL_BLACK_PIECES]
    threats = DIRECTIONAL_PIECES[direction][enemy_color]
    friendly_enemies = all_enemies - threats

    [allies, threats, friendly_enemies]
  end

  # search in a straight line depending on the given direction
  def straight_path_traversal(start, delta, board)
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

  # check if the coordinates is within board bounds
  def inbound?(current_x, current_y)
    current_x.between?(0, 7) && current_y.between?(0, 7)
  end
end

# DummyClass = Class.new do
#   include CheckFinder
# end
# dummy = DummyClass.new
