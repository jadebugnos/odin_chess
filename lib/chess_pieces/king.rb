require_relative '../pieces'

class King < ChessPiece
  def initialize
    unicode = ['♔', '♚'] # [white, black]
    legal_moves = [
      [-1, -1], [-1, 0], [-1, 1],
      [0, -1], [0, 1],
      [1, -1], [1, 0], [1, 1]
    ]
    super(unicode, legal_moves)
  end
end
