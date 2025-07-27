require_relative '../pieces'
require_relative '../positions'

class Pawn < ChessPiece
  WHITE_MOVES = [[-1, 0], [-2, 0]].freeze
  BLACK_MOVES = [[1, 0], [2, 0]].freeze

  WHITE_CAPTURE_DELTAS = [[-1, -1], [-1, 1]].freeze
  BLACK_CAPTURE_DELTAS = [[1, -1], [1, 1]].freeze

  def initialize
    unicode = ["\u2659", "\u265F"] # [white, black]
    super(unicode)
  end

  # Overrides the inherited method to add pawn-specific rules.
  # Includes additional logic to restrict two-step moves to the initial position.
  def legal_move?(move, _board, color)
    legal_moves = color == :white ? WHITE_MOVES : BLACK_MOVES
    from = move[0]
    to = move[1]

    # Calculate delta (to - from)
    delta_move = [to[0] - from[0], to[1] - from[1]]

    legal_moves.include?(delta_move) && handle_initial_position?(color, move)
  end

  # If the move is a normal forward move (not diagonal):
  # - If the destination cell is empty, return true
  # - If the destination cell has any piece (even enemy), return false

  # If the move is a diagonal (capture move):
  # - If the destination cell contains an enemy piece, return true
  # - If the destination cell is empty or has a same-color piece, return false
  def pawn_valid_destination?(move, board, color)
    normal, capture = color == :white ? [WHITE_MOVES, WHITE_CAPTURE_DELTAS] : [BLACK_MOVES, BLACK_CAPTURE_DELTAS]
    from_x, from_y = move[0]
    to_x, to_y = move[1]
    delta = handle_deltas(from_x, to_x, from_y, to_y)
    destination = board[to_x][to_y]

    if normal.include?(delta)
      if destination == ''
        true
      elsif board[to_x][to_y] != ''
        false
      end
    elsif capture.include?(delta)
      piece = color == :white ? :black : :white
      icon = board[to_x][to_y]
      Positions::INITIAL_POSITIONS[piece].key?(icon) || false
    end
  end

  private

  # Pawn-specific helper for checking if a two-step move is allowed.
  # Returns false if the pawn attempts a two-step move from a non-starting row.
  def handle_initial_position?(color, move)
    from = move[0]
    to = move[1]
    delta = [to[0] - from[0], to[1] - from[1]]

    if color == :white && delta == [-2, 0] && from[0] != 6
      return false
    elsif color == :black && delta == [2, 0] && from[0] != 1
      return false
    end

    true
  end
end

# board = Array.new(8) { Array.new(8, '') }
# board[2][3] = '♙'
# move = [[1, 4], [2, 3]]
# color = :black

# pawn = Pawn.new

# pawn.pawn_valid_destination?(move, board, color)
