require_relative 'pieces'
require_relative 'positions'

# this file holds the ChessBoard class which holds all game board logic
class ChessBoard
  attr_accessor :board, :current_positions

  def initialize
    @board = Array.new(8) { Array.new(8, '') }
    @chess_pieces = ChessPiece.new
    @current_positions = {}
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

  # moves the piece to a target cell
  def move_piece(move, board)
    update_positions(move, board)
    (from_x, from_y), (to_x, to_y) = move

    icon = board[from_x][from_y]
    board[from_x][from_y] = ''
    board[to_x][to_y] = icon
  end

  def update_positions(move, board)
    (from_x, from_y), (to_x, to_y) = move
    icon = board[from_x][from_y]
    enemy_piece = board[to_x][to_y]

    # delete old position
    @current_positions[icon].delete([from_x, from_y])
    # add new position
    @current_positions[icon] << [to_x, to_y]

    # remove captured piece from cache
    return unless enemy_piece != '' && @current_positions.key?(enemy_piece)

    @current_positions[enemy_piece].delete([to_x, to_y])
  end

  def cache_current_positions
    @current_positions.clear
    @board.each_with_index.flat_map do |row, x|
      row.each_with_index.filter_map do |piece, y|
        next if piece == ''

        if @current_positions.key?(piece)
          @current_positions[piece] << [x, y]
        else
          @current_positions[piece] = [[x, y]]
        end
      end
    end
  end

  def get_king_position(color)
    king_icon = color == :white ? '♔' : '♚'
    @current_positions[king_icon].first
  end

  private

  def add_pieces(board, key, positions)
    positions.each do |x, y|
      board[x][y] = key
    end
  end
end
