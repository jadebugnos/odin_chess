require_relative '../pieces'

class Rook < ChessPiece
  def initialize # rubocop:disable Lint/MissingSuper
    @unicode = ["\u2656", "\u265C"] # [white, black]
    @legal_directions = [
      [-1, 0],  # up
      [1, 0],   # down
      [0, -1],  # left
      [0, 1]    # right
    ]
  end

  def legal_move?(move, board, *_args)
    from_x, from_y = move[0]
    to_x, to_y     = move[1]

    delta = handle_deltas(from_x, to_x, from_y, to_y)

    return false unless @legal_directions.include?(delta)

    start = move[0]
    destination = move[1]

    valid_path?(start, destination, delta, board)
  end

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
end
