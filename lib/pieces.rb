# Represents a chess piece and its movement logic.
#
# This class encapsulates the rules for determining whether a given move
# is valid for a piece, depending on whether it moves in fixed deltas
# (e.g., knights, kings) or along directions (e.g., rooks, bishops, queens).
class ChessPiece
  # Pieces that move with fixed deltas rather than sliding directions.
  FIXED_DELTA_PIECES = ['♘', '♞', '♔', '♚'].freeze

  # Initializes a chess piece.
  #
  # @param uni [String, nil] Unicode representation of the piece.
  # @param lgm [Array<Array<Integer>>, nil] List of allowed fixed deltas (for knights, kings, pawns).
  # @param lgd [Array<Array<Integer>>, nil] List of allowed directions (for rooks, bishops, queens).
  def initialize(uni = nil, lgm = nil, lgd = nil)
    @unicode = uni
    @legal_moves = lgm
    @legal_directions = lgd
  end

  # Determines whether a move is legal for this piece.
  #
  # For fixed-delta pieces (e.g., knights, kings), validates against move patterns.
  # For sliding pieces (e.g., rooks, bishops, queens), checks both direction and path clearance.
  #
  # @param move [Array<Array<Integer>>] From and to coordinates: [[from_x, from_y], [to_x, to_y]].
  # @param board [Array<Array<String>>] The current chessboard state.
  # @return [Boolean] true if the move is legal, false otherwise.
  def legal_move?(move, board, *_args)
    (from_x, from_y), (to_x, to_y) = move

    return matches_pattern?(move) if FIXED_DELTA_PIECES.include?(board[from_x][from_y])

    delta = handle_deltas(from_x, to_x, from_y, to_y)

    return false unless @legal_directions.include?(delta)

    start = move[0]
    destination = move[1]

    valid_path?(start, destination, delta, board)
  end

  private

  # Computes the delta (step direction) between two coordinates.
  #
  # @param from [Integer] Starting coordinate.
  # @param to [Integer] Target coordinate.
  # @return [Integer] -1 if decreasing, 1 if increasing, 0 if unchanged.
  def get_delta(from, to)
    if from < to
      1
    elsif from > to
      -1
    else
      0
    end
  end

  # Computes the directional delta vector between two coordinates.
  #
  # @param from_x [Integer] Starting row.
  # @param to_x [Integer] Target row.
  # @param from_y [Integer] Starting column.
  # @param to_y [Integer] Target column.
  # @return [Array<Integer>] Delta as [dx, dy].
  def handle_deltas(from_x, to_x, from_y, to_y)
    delta_x = get_delta(from_x, to_x)
    delta_y = get_delta(from_y, to_y)
    [delta_x, delta_y]
  end

  # Checks if the path between two squares is clear in a given direction.
  #
  # @param start [Array<Integer>] Starting coordinates [row, col].
  # @param destination [Array<Integer>] Target coordinates [row, col].
  # @param direction [Array<Integer>] Movement step [dx, dy].
  # @param board [Array<Array<String>>] Current chessboard state.
  # @return [Boolean] true if no blocking pieces are encountered, false otherwise.
  def valid_path?(start, destination, direction, board)
    current_x = start[0] + direction[0]
    current_y = start[1] + direction[1]

    while current_x.between?(0, 7) && current_y.between?(0, 7)
      return true if destination == [current_x, current_y]

      return false unless board[current_x][current_y] == ''

      current_x += direction[0]
      current_y += direction[1]
    end

    false
  end

  # Determines if a move matches the piece's allowed fixed-move patterns.
  #
  # @param move [Array<Array<Integer>>] From and to coordinates.
  # @return [Boolean] true if the move is valid according to fixed deltas.
  def matches_pattern?(move)
    from = move[0]
    to = move[1]

    delta_move = [to[0] - from[0], to[1] - from[1]]

    @legal_moves.include?(delta_move)
  end
end
