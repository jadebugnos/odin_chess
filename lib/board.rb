# this file holds the ChessBoard class which holds all game board logic
class ChessBoard
  def initialize
    @board = nil
  end

  def create_board
    if @board.nil?
      @board = Array.new(8) { Array.new(8, '|  |') }
    else
      @board
    end
  end
end
