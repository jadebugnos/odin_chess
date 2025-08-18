require_relative 'pieces'
require_relative 'positions'

# Represents the chessboard and handles all board-related logic.
#
# Responsible for piece placement, movement, board display,
# and tracking positions of all active pieces.
class ChessBoard
  attr_accessor :board, :current_positions

  # Initializes an empty 8x8 board and sets up piece tracking.
  def initialize
    @board = Array.new(8) { Array.new(8, '') }
    @chess_pieces = ChessPiece.new
    @current_positions = {}
  end

  # Places all initial white and black pieces on the board.
  #
  # @return [void]
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

  # Displays the current state of the board in the console.
  #
  # @return [void]
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

  # Moves a piece on the board and updates position cache.
  #
  # @param move [Array<Array<Integer>>] The move as [[from_x, from_y], [to_x, to_y]].
  # @param board [Array<Array<String>>] The board state.
  # @return [void]
  def move_piece(move, board)
    update_positions(move, board)
    (from_x, from_y), (to_x, to_y) = move

    icon = board[from_x][from_y]
    board[from_x][from_y] = ''
    board[to_x][to_y] = icon
  end

  # Updates internal cache of piece positions after a move.
  #
  # @param move [Array<Array<Integer>>] The move coordinates.
  # @param board [Array<Array<String>>] The board state.
  # @return [void]
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

  # Rebuilds the cache of all piece positions from the current board state.
  #
  # @return [void]
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

  # Returns the current position of the king of a given color.
  #
  # @param color [Symbol] :white or :black.
  # @return [Array<Integer>] The coordinates [x, y] of the king.
  def get_king_position(color)
    king_icon = color == :white ? '♔' : '♚'
    @current_positions[king_icon].first
  end

  private

  # Adds specific pieces to the board at given positions.
  #
  # @param board [Array<Array<String>>] The board state.
  # @param key [String] The piece symbol.
  # @param positions [Array<Array<Integer>>] The list of coordinates.
  # @return [void]
  def add_pieces(board, key, positions)
    positions.each do |x, y|
      board[x][y] = key
    end
  end
end
