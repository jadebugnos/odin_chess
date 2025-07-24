require_relative '../pieces'

class Knight < ChessPiece
  def initialize
    unicode = ['♘', '♞'] # [white, black]
    legal_moves = [
      [-2, -1], [-2, 1],
      [-1, -2], [-1, 2],
      [1, -2],  [1, 2],
      [2, -1],  [2, 1]
    ]
    super(unicode, legal_moves)
  end
end
