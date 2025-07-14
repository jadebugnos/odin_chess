require_relative '../pieces'

class Pawn < ChessPiece
  def initialize
    @unicode = ["\u2659", "\u265F"] # [white, black]
    @legal_moves_white = [[-1, 0], [-1, -1], [-1, 1]]
    @legal_moves_black = [[1, 0], [1, -1], [1, 1]]
  end
end
