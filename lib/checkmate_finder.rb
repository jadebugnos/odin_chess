require_relative 'check_finder'
require_relative 'positions'
require_relative 'move_validator'
require 'pry-byebug'

module CheckmateFinder
  include CheckFinder
  include MoveValidator

  # Checks if the current player's king is in checkmate.
  #
  # First checks if the king is in check using `check_found?`.
  # If a threat is detected, it attempts to determine if the check
  # can be escaped or defended against.
  #
  # @param color [Symbol] the color of the player's pieces (:white or :black)
  # @param board [Array<Array>] the current 2D board state
  # @param king_pos [Array<Integer>] coordinates of the king [x, y]
  # @return [Boolean] true if checkmate is found, false otherwise
  def checkmate?(color, board, king_pos)
    threat_pos = [] # Will store [threat_coordinates, direction] if check is found

    return false unless check_found?(color, board, king_pos, threat_pos)

    checkmate_found?(color, board, king_pos, threat_pos)
  end

  # Determines if a checkmate condition is met by verifying that:
  # - The king cannot move to any safe square (no_escape)
  # - The threat cannot be neutralized by capturing or blocking (no_defense)
  #
  # @param color [Symbol] the color of the player's pieces
  # @param board [Array<Array>] the current board state
  # @param king_pos [Array<Integer>] king's coordinates
  # @param threat_pos [Array] the threat info: [coordinates, direction]
  # @return [Boolean] true if no escape and no defense is possible
  def checkmate_found?(color, board, king_pos, threat_pos)
    no_escape = !escape_search?(color, board, king_pos)
    no_defense = !defense_search?(color, board, king_pos, threat_pos)

    no_escape && no_defense
  end

  # Searches for any valid escape squares the king can move to.
  # It checks all adjacent cells to see if any are either empty
  # or contain an enemy piece and are not under attack.
  #
  # @param color [Symbol] the color of the player's pieces
  # @param board [Array<Array>] the current board state
  # @param king_pos [Array<Integer>] king's current position
  # @return [Boolean] true if there's at least one escape square, false otherwise
  def escape_search?(color, board, king_pos)
    king_deltas = CheckConstants::KING_DELTAS
    enemy_pieces = color == :black ? CheckConstants::ALL_WHITE_PIECES : CheckConstants::ALL_BLACK_PIECES

    adjacent_cell_traversal?(king_pos, king_deltas) do |x, y|
      cell_content = board[x][y]

      next false unless cell_content == '' || enemy_pieces.include?(cell_content)

      !check_found?(color, board, [x, y], nil)
    end
  end

  # Iterates over all adjacent cells of the king's position
  # and checks a condition for each using the given deltas.
  #
  # @param king_pos [Array<Integer>] the king’s current position
  # @param deltas [Array<Array>] movement offsets to check (e.g., KING_DELTAS)
  # @yield [x, y] each neighboring cell’s coordinates
  # @return [Boolean] true if any of the adjacent cells meet the block condition
  def adjacent_cell_traversal?(king_pos, deltas)
    deltas.any? do |dx, dy|
      x = king_pos[0] + dx
      y = king_pos[1] + dy

      next false unless inbound?(x, y)

      yield(x, y) if block_given?
    end
  end

  # Determines if the king can be defended by:
  # - Capturing the threatening piece
  # - Blocking the path of the threat (if it's a sliding piece)
  #
  # @param color [Symbol] the color of the player's pieces
  # @param board [Array<Array>] the current board state
  # @param king_pos [Array<Integer>] the king's position
  # @param threat_pos [Array] the threat info: [coordinates, direction]
  # @return [Boolean] true if a defense is possible, false otherwise
  def defense_search?(color, board, king_pos, threat_pos)
    pos, dir = threat_pos
    coordinates = get_coordinates(board, color)

    capturable = threat_capturable?(color, board, pos, coordinates, king_pos)
    blockable = threat_blockable?(color, board, king_pos, pos, dir, coordinates)

    capturable || blockable
  end

  # Determines if the threatening piece can be captured by any allied piece.
  #
  # This method checks if any allied piece can legally move to the position of the threat,
  # simulating a potential capture. It does not verify whether the move exposes the king to check;
  # that validation is assumed to be handled in the overall checkmate logic.
  #
  # @param color [Symbol] the color of the player's pieces (:white or :black)
  # @param board [Array<Array>] the current board state
  # @param pos [Array<Integer>] coordinates of the threatening piece [x, y]
  # @param coordinates [Array<Array>] positions of all allied pieces [[x1, y1], [x2, y2], ...]
  # @return [Boolean] true if at least one allied piece can legally capture the threat, false otherwise
  def threat_capturable?(color, board, pos, coordinates, king_pos)
    target_x, target_y = pos

    simulate_move(target_x, target_y, coordinates, board, color, king_pos)
  end

  # Determines if a threat to the king can be blocked by an allied piece.
  #
  # @param color [Symbol] the color of the player's pieces (:white or :black)
  # @param board [Array<Array>] the current 2D board state
  # @param king_pos [Array<Integer>] coordinates of the king under threat [x, y]
  # @param pos [Array<Integer>] coordinates of the threatening piece [x, y]
  # @param dir [Symbol] the direction of the threat (:linear or :diagonal)
  # @param coordinates [Array<Array>] positions of all allied pieces [[x1, y1], [x2, y2], ...]
  # @return [Boolean] true if an allied piece can block the threat, false otherwise
  def threat_blockable?(color, board, king_pos, pos, dir, coordinates)
    return false unless %i[linear diagonal].include?(dir)

    delta = handle_deltas(pos[0], king_pos[0], pos[1], king_pos[1])

    follow_path(board, color, pos, coordinates, delta, king_pos)
  end

  # Traverses the path from the threatening piece toward the king
  # and checks if any allied piece can move to a square along the path
  # to block the check.
  #
  # @param board [Array<Array>] the current 2D board state
  # @param color [Symbol] the color of the player's pieces
  # @param pos [Array<Integer>] coordinates of the threatening piece [x, y]
  # @param coordinates [Array<Array>] list of all allied piece positions [[x1, y1], [x2, y2], ...]
  # @param delta [Array<Integer>] the step direction toward the king [dx, dy]
  # @param king_pos [Array<Integer>] coordinates of the player's king piece [x, y]
  # @return [Boolean] true if any allied piece can move into the path, false otherwise
  def follow_path(board, color, pos, coordinates, delta, king_pos)
    check_path_traversal(pos, delta, king_pos) do |target_x, target_y|
      return true if simulate_move(target_x, target_y, coordinates, board, color, king_pos)
    end
    false
  end

  # Simulates if any allied piece can move to a target position and legally capture a threat.
  #
  # @param target_x [Integer] the x-coordinate of the square to test
  # @param target_y [Integer] the y-coordinate of the square to test
  # @param coordinates [Array<Array>] list of allied piece positions [[x, y], ...]
  # @param board [Array<Array>] the current 2D board state
  # @param color [Symbol] the color of the player's pieces
  # @return [Boolean] true if any piece can legally move to the target square
  def simulate_move(target_x, target_y, coordinates, board, color, king_pos = nil)
    coordinates.any? do |ally_x, ally_y|
      move = [[ally_x, ally_y], [target_x, target_y]]
      check_if_valid_move?(move, board, color, king_pos)
    end
  end

  # Iterates through a linear path based on a starting position and delta,
  # yielding each cell coordinate along the way until the target position is reached.
  #
  # @param start [Array<Integer>] starting position [x, y]
  # @param delta [Array<Integer>] direction of traversal [dx, dy]
  # @param target [Array<Integer>] final position to stop at [x, y]
  # @yield [x, y] coordinates of each cell visited along the path
  def check_path_traversal(start, delta, target)
    x = start[0] + delta[0]
    y = start[1] + delta[1]

    while inbound?(x, y)
      break if target == [x, y]

      yield(x, y) if block_given?

      x += delta[0]
      y += delta[1]
    end
  end

  # Returns the coordinates of all allied pieces on the board, excluding the king.
  #
  # Iterates through the board and collects the positions of all pieces that belong to the
  # specified color. The king's position is intentionally excluded since it is handled separately
  # in check/checkmate logic.
  #
  # @param board [Array<Array>] the current 2D board state
  # @param color [Symbol] the color of the player's pieces (:white or :black)
  # @return [Array<Array>] a list of coordinates [[x1, y1], [x2, y2], ...] for allied pieces
  def get_coordinates(board, color)
    allied_pieces = Positions::INITIAL_POSITIONS
    kings = { white: '♔', black: '♚' }

    board.each_with_index.flat_map do |row, x|
      row.each_with_index.filter_map do |piece, y|
        next if kings[color] == piece

        [x, y] if allied_pieces[color].key?(piece)
      end
    end
  end

  # Returns an integer delta (-1, 0, or 1) representing the direction of movement.
  #
  # @param from [Integer] starting coordinate
  # @param to [Integer] ending coordinate
  # @return [Integer] the step direction: -1 (decrease), 1 (increase), or 0 (no movement)
  def get_delta(from, to)
    if from < to
      1
    elsif from > to
      -1
    else
      0
    end
  end

  def handle_deltas(from_x, to_x, from_y, to_y)
    delta_x = get_delta(from_x, to_x)
    delta_y = get_delta(from_y, to_y)
    [delta_x, delta_y]
  end
end
