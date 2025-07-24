require_relative '../pieces'

class Bishop < ChessPiece
  def initialize
    unicode = ['♗', '♝'] # [white, black]
    legal_directions = [
      [-1, -1], [-1, 1],
      [1, -1],  [1, 1]
    ]
    super(unicode, nil)
    @legal_directions = legal_directions
  end
end
