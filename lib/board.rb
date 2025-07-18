require_relative 'pieces'
require_relative 'positions'

# this file holds the ChessBoard class which holds all game board logic
class ChessBoard
  def initialize
    @board = Array.new(8) { Array.new(8, '') }
    @chess_pieces = ChessPiece.new
  end

  def set_up_pieces
    # adding white pieces
    Positions::INITIAL_POSITIONS[:white].each do |unicode, coordinates|
      add_pieces(@board, unicode, coordinates)
    end

    # adding black pieces
    Positions::INITIAL_POSITIONS[:black].each do |unicode, coordinates|
      add_pieces(@board, unicode, coordinates)
    end
  end

  # holds the board displaying logic
  def display_board
    horizontal = "  +#{'---+' * 8}"
    i = 8
    @board.each do |row|
      puts horizontal
      puts "#{i} |" + row.map { |cell| "#{cell.center(3)}|" }.join
      i -= 1
    end
    puts horizontal
    puts '    ' + ('a'..'h').map { |c| c.center(4) }.join # rubocop:disable Style/StringConcatenation
  end

  def update_board; end

  private

  def add_pieces(board, key, positions)
    positions.each do |x, y|
      board[x][y] = key
    end
  end
end
