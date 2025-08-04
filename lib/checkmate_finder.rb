require_relative 'check_finder'

module CheckmateFinder
  include CheckFinder

  def checkmate?(color, board, king_position)
    return false unless check_found?(color, board, king_position)

    checkmate_found?(color, board, king_position)
  end

  def checkmate_found?(color, board, king_position)
    no_escape = !adjacent_cell_search?(color, board, king_position)
    no_defense = !check_path_search?(color, board, king_position)

    no_escape && no_defense
  end

  def adjacent_cell_search?(color, board, king_position)
    king_deltas = CheckConstants::KING_DELTAS

    adjacent_cell_traversal?(king_position, king_deltas) do |x, y|
      next false unless board[x][y] == ''

      !check_found?(color, board, [x, y])
    end
  end

  def adjacent_cell_traversal?(king_position, deltas)
    deltas.any? do |dx, dy|
      x = king_position[0] + dx
      y = king_position[1] + dy

      next false unless inbound?(x, y)

      yield(x, y) if block_given?
    end
  end
end
