require_relative 'check_constants'

module CheckFinder
  include CheckConstants

  # Determines if the king is currently in check.
  #
  # @param color [Symbol] The color of the current player (:white or :black).
  # @param board [Array<Array<String>>] 2D array representing the chessboard.
  # @param king_position [Array<Integer>] Coordinates of the king piece [row, col].
  # @param threat [Array] (optional) Container to collect threat coordinates.
  # @return [Boolean] true if the king is in check, false otherwise.
  def check_found?(color, board, king_position, threat = nil)
    diagonal_search?(color, board, king_position, threat) ||
      linear_search?(color, board, king_position, threat) ||
      knight_search?(color, board, king_position, threat) ||
      pawn_search?(color, board, king_position, threat) ||
      king_search?(color, board, king_position, threat)
  end

  # Searches along directional deltas from the king's position to detect threats.
  #
  # @param color [Symbol] Current player's color.
  # @param board [Array<Array<String>>] 2D chessboard array.
  # @param start [Array<Integer>] Starting coordinates (king position).
  # @param deltas [Array<Array<Integer>>] Movement offsets for the search.
  # @param direction [Symbol] Type of direction (:diagonal, :linear, etc.).
  # @param threats [Array] (optional) Container to collect threat coordinates.
  # @return [Boolean] true if a threatening enemy is found, false otherwise.
  def directional_search?(color, board, start, deltas, direction, threats = nil)
    ally, enemy, friendly_enemies = identify_threats_and_allies(color, direction)

    deltas.any? do |delta|
      straight_path_traversal(start, delta, board) do |cell, x, y|
        next if cell == ''

        next false if ally.include?(cell) || friendly_enemies.include?(cell)

        if enemy.include?(cell)
          # optional collection of threat coordinates and it's direction
          threats&.push([x, y], direction)
          break true
        end
      end
    end
  end

  # Checks for threats from bishops or queens (diagonal movement).
  #
  # @param color [Symbol]
  # @param board [Array<Array<String>>]
  # @param king_position [Array<Integer>]
  # @param threat [Array] (optional)
  # @return [Boolean]
  def diagonal_search?(color, board, king_position, threat = nil)
    directional_search?(color, board, king_position, DIAGONAL_DELTAS, :diagonal, threat)
  end

  # Checks for threats from rooks or queens (linear movement).
  #
  # @param color [Symbol]
  # @param board [Array<Array<String>>]
  # @param king_position [Array<Integer>]
  # @param threat [Array] (optional)
  # @return [Boolean]
  def linear_search?(color, board, king_position, threat = nil)
    directional_search?(color, board, king_position, LINEAR_DELTAS, :linear, threat)
  end

  # Checks for threats from knights.
  #
  # @param color [Symbol]
  # @param board [Array<Array<String>>]
  # @param king_position [Array<Integer>]
  # @param threat [Array] (optional)
  # @return [Boolean]
  def knight_search?(color, board, king_position, threat = nil)
    fixed_search?(color, board, king_position, KNIGHT_DELTAS, :knight, threat)
  end

  # Checks for threats from enemy pawns.
  #
  # @param color [Symbol]
  # @param board [Array<Array<String>>]
  # @param king_position [Array<Integer>]
  # @param threat [Array] (optional)
  # @return [Boolean]
  def pawn_search?(color, board, king_position, threat = nil)
    enemy_color = color == :black ? :white : :black

    pawn_deltas = PAWN_DELTAS[enemy_color]

    fixed_search?(color, board, king_position, pawn_deltas, :pawn, threat)
  end

  # Checks for threats from the opposing king.
  # (Illegal in chess, but still treated as a detectable threat.)
  #
  # @param color [Symbol]
  # @param board [Array<Array<String>>]
  # @param king_position [Array<Integer>]
  # @param threat [Array] (optional)
  # @return [Boolean]
  def king_search?(color, board, king_position, threat = nil)
    fixed_search?(color, board, king_position, KING_DELTAS, :king, threat)
  end

  # Shared logic for detecting threats from fixed-delta pieces (knight, pawn, king).
  #
  # @param color [Symbol]
  # @param board [Array<Array<String>>]
  # @param king_pos [Array<Integer>]
  # @param deltas [Array<Array<Integer>>] Movement offsets to check.
  # @param direction [Symbol] Piece type (:knight, :pawn, :king).
  # @param threats [Array] (optional)
  # @return [Boolean]
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

  # Traverses a set of fixed deltas around the king’s position.
  #
  # @param board [Array<Array<String>>]
  # @param king_position [Array<Integer>]
  # @param deltas [Array<Array<Integer>>]
  # @yield [cell, x, y] Executes a block for each checked square.
  # @yieldparam cell [String] The piece or empty string at the position.
  # @yieldparam x [Integer] Row coordinate.
  # @yieldparam y [Integer] Column coordinate.
  # @return [Boolean] true if a block returns true, false otherwise.
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

  # Identifies allies, threatening enemies, and non-threatening enemies.
  #
  # @param color [Symbol]
  # @param direction [Symbol]
  # @return [Array<Array<String>, Array<String>, Array<String>>]
  #   Returns [allies, threats, friendly_enemies].
  def identify_threats_and_allies(color, direction)
    enemy_color = color == :black ? :white : :black

    allies, all_enemies = color == :black ? [ALL_BLACK_PIECES, ALL_WHITE_PIECES] : [ALL_WHITE_PIECES, ALL_BLACK_PIECES]
    threats = DIRECTIONAL_PIECES[direction][enemy_color]
    friendly_enemies = all_enemies - threats

    [allies, threats, friendly_enemies]
  end

  # Traverses squares in a straight line until blocked or out of bounds.
  #
  # @param start [Array<Integer>] Starting coordinates [row, col].
  # @param delta [Array<Integer>] Step movement [dx, dy].
  # @param board [Array<Array<String>>]
  # @yield [cell, x, y] Executes a block for each square in path.
  # @yieldparam cell [String] The piece or empty string at the position.
  # @yieldparam x [Integer]
  # @yieldparam y [Integer]
  # @return [Boolean] true if threat found, false otherwise.
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

  # Checks if given coordinates are within chessboard bounds.
  #
  # @param current_x [Integer]
  # @param current_y [Integer]
  # @return [Boolean] true if coordinates are inside the board, false otherwise.
  def inbound?(current_x, current_y)
    current_x.between?(0, 7) && current_y.between?(0, 7)
  end
end
