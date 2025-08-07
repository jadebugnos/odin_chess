require_relative 'check_constants'
require 'pry-byebug'

module CheckFinder
  include CheckConstants

  # this method returns true if a check is found otherwise false.
  # arguments in order:
  # color - color of the current player
  # board - 2D array that represent the chess board
  # king_position - the position of the king piece
  def check_found?(color, board, king_position, threat = nil)
    diagonal_search?(color, board, king_position, threat) ||
      linear_search?(color, board, king_position, threat) ||
      knight_search?(color, board, king_position, threat) ||
      pawn_search?(color, board, king_position, threat) ||
      king_search?(color, board, king_position, threat)
  end

  # search based of a given delta from the POV of King piece. returns true
  # if the cell contains an enemy piece that captures with the same direction
  # otherwise returns false
  # *args in order:
  # color - the current players color
  # board - A 2D array representing the Chessboard
  # start - the coordinates of the king piece
  # threats - an empty array used as container to collect threat coordinates
  # deltas - the directions in which to search
  # direction - direction of the piece. eg. :diagonal, :linear etc.
  def directional_search?(color, board, start, deltas, direction, threats = nil)
    # binding.pry
    ally, enemy, friendly_enemies = identify_threats_and_allies(color, direction)

    deltas.any? do |delta|
      straight_path_traversal(start, delta, board) do |cell, x, y|
        next if cell == ''

        next false if ally.include?(cell) || friendly_enemies.include?(cell)

        if enemy.include?(cell)
          # optional collection of threat coordinates and it's direction
          threats << [[x, y], direction] if threats
          break true
        end
      end
    end
  end

  # Checks if the king is in check from diagonal threats (bishops or queens)
  # *args in order:
  # color, board, king_position
  def diagonal_search?(color, board, king_position, threat = nil)
    directional_search?(color, board, king_position, DIAGONAL_DELTAS, :diagonal, threat)
  end

  # Checks if the king is in check from linear threats (rooks or queens).
  # *args in order: color, board, king_position
  def linear_search?(color, board, king_position, threat = nil)
    directional_search?(color, board, king_position, LINEAR_DELTAS, :linear, threat)
  end

  # Checks if the king is in check from a knight.
  # *args in order: color, board, king_position
  def knight_search?(color, board, king_position, threat = nil)
    fixed_search?(color, board, king_position, KNIGHT_DELTAS, :knight, threat)
  end

  # Checks if the king is in check from an enemy pawn.
  # *args in order: color, board, king_position
  def pawn_search?(color, board, king_position, threat = nil)
    enemy_color = color == :black ? :white : :black

    pawn_deltas = PAWN_DELTAS[enemy_color]

    fixed_search?(color, board, king_position, pawn_deltas, :pawn, threat)
  end

  # Checks if the king is in check from the opposing king (illegal but detected as threat).
  # args in order: color, board, king_position
  def king_search?(color, board, king_position, threat = nil)
    fixed_search?(color, board, king_position, KING_DELTAS, :king, threat)
  end

  # Shared logic for fixed-delta piece threats (knights, pawns, kings).
  # Traverses a fixed set of deltas and returns true if any threatening enemy is found.
  # *args in order: color, board, king_pos,threat, deltas, direction
  def fixed_search?(color, board, king_pos, deltas, direction, threats = nil)
    ally, enemy, friendly_enemies = identify_threats_and_allies(color, direction)

    fixed_path_traversal(board, king_pos, deltas) do |cell, x, y|
      next false if cell == ''

      next false if ally.include?(cell) || friendly_enemies.include?(cell)

      if enemy.include?(cell)
        # optional collection of threat coordinates and it's direction
        threats&.push([x, y], direction)
        return true
      end
    end
  end

  # From the king's point of view, check surrounding squares based on fixed deltas
  # to detect immediate threats (e.g., knights, pawns, king)
  # *args in order: board, king_position, deltas
  def fixed_path_traversal(board, king_position, deltas)
    deltas.any? do |dx, dy|
      current_x = king_position[0] + dx
      current_y = king_position[1] + dy

      next false unless inbound?(current_x, current_y)

      current_position = board[current_x][current_y]

      yield(current_position, current_x, current_y) if block_given?
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
  # *args in order: start, delta, board
  def straight_path_traversal(start, delta, board)
    current_x = start[0] + delta[0]
    current_y = start[1] + delta[1]

    while inbound?(current_x, current_y)
      next_cell = board[current_x][current_y]

      result = yield(next_cell, current_x, current_y) if block_given?
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
