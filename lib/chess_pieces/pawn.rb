require_relative '../pieces'

class Pawn < ChessPiece
  def initialize # rubocop:disable Lint/MissingSuper
    @unicode = ["\u2659", "\u265F"] # [white, black]
    @legal_moves_white = [[-1, 0], [-2, 0], [-1, -1], [-1, 1]]
    @legal_moves_black = [[1, 0], [2, 0], [1, -1], [1, 1]]
  end

  # Overrides the inherited method to add pawn-specific rules.
  # Includes additional logic to restrict two-step moves to the initial position.
  def legal_move?(move, _board, color)
    legal_moves = color == :white ? @legal_moves_white : @legal_moves_black
    from = move[0]
    to = move[1]

    # Calculate delta (to - from)
    delta_move = [to[0] - from[0], to[1] - from[1]]

    legal_moves.include?(delta_move)

    handle_initial_position?(color, move)
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
