# this file defines the Pieces class which holds the chess pieces logic
class ChessPiece
  def initialize(uni = nil, lwm = nil, lbm = nil)
    @unicode = uni
    @legal_moves_white = lwm
    @legal_moves_black = lbm
  end

  def legal_move?(color, move)
    legal_moves = color == :white ? @legal_moves_white : @legal_moves_black
    from = move[0]
    to = move[1]

    # Calculate delta (to - from)
    delta_move = [to[0] - from[0], to[1] - from[1]]

    legal_moves.include?(delta_move)
  end

  # moves the piece to a target cell
  # use this method only if all requirements are met:
  # - move is legal depending on the piece legal moves
  # - target cell is inbound the board
  # - the cell is empty
  # - their is no obstruction along the way unless it's horse
  def move_piece(board, current, target)
    board[current[0]][current[1]] = ''
    board[target[0]][target[1]] = @unicode
  end
end
