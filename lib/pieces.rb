# this file defines the Pieces class which holds the chess pieces logic
class ChessPiece
  FIXED_DELTA_PIECES = ['♘', '♞', '♔', '♚'].freeze

  def initialize(uni = nil, lgm = nil, lgd = nil)
    @unicode = uni
    @legal_moves = lgm
    @legal_directions = lgd
  end

  # Checks whether a move is valid based on the piece's movement rules.
  # For fixed-delta pieces (like knights), uses pattern-matching.
  # For directional pieces (like rooks or bishops), checks direction and path clearance.
  def legal_move?(move, board, *_args)
    from_x, from_y = move[0]
    to_x, to_y     = move[1]

    # Use pattern-matching logic for fixed-move pieces (e.g., knight)
    return matches_pattern?(move) if FIXED_DELTA_PIECES.include?(board[from_x][from_y])

    # Calculate the direction of the move
    delta = handle_deltas(from_x, to_x, from_y, to_y)

    # Reject move if it's not in the piece's allowed directions
    return false unless @legal_directions.include?(delta)

    start = move[0]
    destination = move[1]

    # Check if the path from start to destination is clear
    valid_path?(start, destination, delta, board)
  end

  private

  # Returns the step direction between two values:
  # - 1 if moving forward
  # - -1 if moving backward
  # - 0 if no movement
  def get_delta(from, to)
    if from < to
      1
    elsif from > to
      -1
    else
      0
    end
  end

  # Helper method used by #legal_move?
  # Returns the directional delta (as [dx, dy]) between two coordinates
  def handle_deltas(from_x, to_x, from_y, to_y)
    delta_x = get_delta(from_x, to_x)
    delta_y = get_delta(from_y, to_y)
    [delta_x, delta_y]
  end

  # Helper method used by #legal_move? to check if the path is clear.
  # Returns true if the path to the destination is not blocked; false otherwise.
  def valid_path?(start, destination, direction, board)
    # Start at the next square in the given direction
    current_x = start[0] + direction[0]
    current_y = start[1] + direction[1]

    # Keep moving in the direction until we go out of bounds
    while current_x.between?(0, 7) && current_y.between?(0, 7)
      # If we reach the destination square, the path is clear
      return true if destination == [current_x, current_y]

      # If a square is occupied before reaching destination, path is blocked
      return false unless board[current_x][current_y] == ''

      # Move to the next square in the same direction
      current_x += direction[0]
      current_y += direction[1]
    end

    false
  end

  # returns true if the players move is legal otherwise false.
  # Parameters:
  # - color: Symbol representing the player's color (:white or :black).
  #          Used to select the appropriate legal move set.
  # - move: An array of two coordinates [from, to], where each is a [row, col] pair.
  def matches_pattern?(move)
    from = move[0]
    to = move[1]

    # Calculate delta (to - from)
    delta_move = [to[0] - from[0], to[1] - from[1]]

    @legal_moves.include?(delta_move)
  end
end
