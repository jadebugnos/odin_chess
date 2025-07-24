# this file defines the Pieces class which holds the chess pieces logic
class ChessPiece
  FIXED_DELTA_PIECES = ['♘', '♞', '♔', '♚'].freeze

  def initialize(uni = nil, lgm = nil, lgd = nil)
    @unicode = uni
    @legal_moves = lgm
    @legal_directions = lgd
  end

  def legal_move?(move, board, *_args)
    from_x, from_y = move[0]
    to_x, to_y     = move[1]

    return matches_pattern?(move) if FIXED_DELTA_PIECES.include?(board[from_x][from_y])

    delta = handle_deltas(from_x, to_x, from_y, to_y)

    return false unless @legal_directions.include?(delta)

    start = move[0]
    destination = move[1]

    valid_path?(start, destination, delta, board)
  end

  # moves the piece to a target cell
  # use this method only if all requirements are met:
  # - move is legal depending on the piece legal moves
  # - target cell is inbound the board
  # - the cell is empty
  # - their is no obstruction along the way unless it's horse
  def move_piece(board, current, target)
    board[current[0]][current[1]] = ''
    board[target[0]][target[1]] = @unicode
  end

  private

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
