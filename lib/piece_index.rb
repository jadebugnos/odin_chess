require_relative '../lib/chess_pieces/rook'
require_relative '../lib/chess_pieces/knight'
require_relative '../lib/chess_pieces/bishop'
require_relative '../lib/chess_pieces/queen'
require_relative '../lib/chess_pieces/king'
require_relative '../lib/chess_pieces/pawn'

module PieceIndex
  PIECE_HASH = {
    white: {
      "\u2656" => Rook.new,
      "\u2658" => Knight.new,
      "\u2657" => Bishop.new,
      "\u2655" => Queen.new,
      "\u2654" => King.new,
      "\u2659" => Pawn.new
    },
    black: {
      "\u265C" => Rook.new,
      "\u265E" => Knight.new,
      "\u265D" => Bishop.new,
      "\u265B" => Queen.new,
      "\u265A" => King.new,
      "\u265F" => Pawn.new
    }
  }.freeze
end
