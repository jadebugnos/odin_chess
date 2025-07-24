require_relative '../pieces'

class Queen < ChessPiece
  def initialize
    unicode = ['♕', '♛'] # [white, black]
    legal_directions = [
      [-1, 0], [1, 0], [0, -1], [0, 1], # vertical + horizontal (rook)
      [-1, -1], [-1, 1], [1, -1], [1, 1] # diagonals (bishop)
    ]
    super(unicode, nil)
    @legal_directions = legal_directions
  end
end
