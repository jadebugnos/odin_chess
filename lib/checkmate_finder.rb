require_relative 'check_finder'

module CheckmateFinder
  include CheckFinder

  # returns true if a checkmate has been found otherwise false
  def checkmate?(color, board, king_pos)
    # Passed to check_found? to store the coordinates and direction
    # of the threat if a check is detected.
    threat_pos = []

    return false unless check_found?(color, board, king_pos, threat_pos)

    checkmate_found?(color, board, king_pos, threat_pos)
  end

  # Checks if the king has no escape and the check cannot be blocked.
  # Returns true if it's checkmate, otherwise false.
  def checkmate_found?(color, board, king_pos, threat_pos)
    no_escape = !escape_search?(color, board, king_pos)
    no_defense = !defense_search?(color, board, king_pos, threat_pos)

    no_escape && no_defense
  end

  def escape_search?(color, board, king_pos)
    king_deltas = CheckConstants::KING_DELTAS
    enemy_pieces = color == :black ? CheckConstants::ALL_WHITE_PIECES : CheckConstants::ALL_BLACK_PIECES

    adjacent_cell_traversal?(king_pos, king_deltas) do |x, y|
      cell_content = board[x][y]

      next false unless cell_content == '' || enemy_pieces.include?(cell_content)

      !check_found?(color, board, [x, y])
    end
  end

  def adjacent_cell_traversal?(king_pos, deltas)
    deltas.any? do |dx, dy|
      x = king_pos[0] + dx
      y = king_pos[1] + dy

      next false unless inbound?(x, y)

      yield(x, y) if block_given?
    end
  end

  def defense_search?(color, board, king_pos, threat_pos)
    pos, dir = threat_pos

    threat_capturable?(color, board, pos) || threat_blockable?(color, board, king_pos, pos, dir)
  end

  # Simulates a "king" check from the threat’s position and the opposing color
  # to determine if the threat is capturable.
  # *args order: color, board, position
  def threat_capturable?(*args)
    color, board, pos = args
    enemy_color = color == :black ? :white : :black

    check_found?(enemy_color, board, pos)
  end

  # *args order: color, board , king_pos, pos, dir
  # def threat_blockable?(*args)
  #   color, board, king_pos, pos, dir = args

  #   return false unless %i[linear diagonal].include?(dir)

  #   delta = [king_pos[0] - pos[0], king_pos[1] - pos[1]]

  #   check_path_traversal(pos, delta) do |x, y|
  #     check_found?()
  #   end
  # end

  # # *args order: position, delta board
  # def check_path_traversal(*args)
  #   pos, delta, board = args

  #   x = pos[0] + delta[0]
  #   y = pos[1] + delta[1]

  #   while inbound?(x, y)
  #     yield(x, y) if block_given?

  #     x += delta[0]
  #     y += delta[1]
  #   end
  # end
end
