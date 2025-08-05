module CheckConstants
  ALL_BLACK_PIECES = ['♟', '♜', '♝', '♞', '♛', '♚'].freeze
  ALL_WHITE_PIECES = ['♙', '♖', '♗', '♘', '♕', '♔'].freeze

  DIRECTIONAL_PIECES = {
    diagonal: { black: ['♝', '♛'], white: ['♗', '♕'] },
    linear: { black: ['♜', '♛'], white: ['♖', '♕'] },
    knight: { black: ['♞'], white: ['♘'] },
    pawn: { black: ['♟'], white: ['♙'] },
    king: { black: ['♚'], white: ['♔'] }
  }.freeze

  DIAGONAL_DELTAS = [[-1, -1], [-1, 1], [1, -1], [1, 1]].freeze
  LINEAR_DELTAS   = [[-1, 0], [1, 0], [0, -1], [0, 1]].freeze
  KNIGHT_DELTAS   = [[-2, -1], [-2, 1], [-1, -2], [-1, 2],
                     [1, -2], [1, 2], [2, -1], [2, 1]].freeze
  PAWN_DELTAS = { black: [[-1, -1], [-1, 1]], white: [[1, -1], [1, 1]] }.freeze
  KING_DELTAS = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].freeze
end
