require_relative '../pieces'
require_relative '../positions'
require 'pry-byebug'

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
  def legal_move?(move, board, color)
    pawn_valid_destination?(move, board, color)
  end

  # Checks if a pawn move is valid based on movement rules and the board state
  def pawn_valid_destination?(move, board, color)
    # Determine move and capture patterns based on the pawn's color
    normal, capture = color == :white ? [WHITE_MOVES, WHITE_CAPTURE_DELTAS] : [BLACK_MOVES, BLACK_CAPTURE_DELTAS]
    # Destructure the move into starting and ending coordinates
    (from_x, from_y), (to_x, to_y) = move

    # Calculate the difference (delta) between from and to coordinates
    delta = [to_x - from_x, to_y - from_y]
    # Get the piece (if any) at the destination square
    destination = board[to_x][to_y]

    # Valid normal move: if the delta is in the normal list,
    # the destination is empty, and the pawn is allowed to move two squares (from its starting row)
    return true if normal.include?(delta) && destination == '' && handle_initial_position?(color, move)

    # Valid capture move: if the delta is a capture delta and the destination contains an enemy piece
    return true if capture.include?(delta) && destination_has_enemy?(color, destination)

    # If none of the valid conditions are met, return false
    false
  end

  private

  def destination_has_enemy?(color, icon)
    clean_icon = icon.gsub("\uFE0E", '') # remove variation selector if present
    enemy_color = color == :white ? :black : :white

    Positions::INITIAL_POSITIONS[enemy_color].key?(clean_icon)
  end

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
