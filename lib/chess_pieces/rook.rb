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
end
