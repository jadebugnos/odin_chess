require_relative '../lib/board'

RSpec.describe ChessBoard do
  describe '#set_up_pieces' do
    subject(:chess_board) { described_class.new }
    let(:chess_pieces) do
      double('chess_pieces', positions: {
               white: {
                 "\u2656" => [[7, 0], [7, 7]],                     # ♖ rook
                 "\u2658" => [[7, 1], [7, 6]],                     # ♘ knight
                 "\u2657" => [[7, 2], [7, 5]],                     # ♗ bishop
                 "\u2655" => [[7, 3]],                             # ♕ queen
                 "\u2654" => [[7, 4]],                             # ♔ king
                 "\u2659" => (0..7).map { |col| [6, col] }         # ♙ pawn
               },
               black: {
                 "\u265C" => [[0, 0], [0, 7]],                     # ♜ rook
                 "\u265E" => [[0, 1], [0, 6]],                     # ♞ knight
                 "\u265D" => [[0, 2], [0, 5]],                     # ♝ bishop
                 "\u265B" => [[0, 3]],                             # ♛ queen
                 "\u265A" => [[0, 4]],                             # ♚ king
                 "\u265F" => (0..7).map { |col| [1, col] }         # ♟ pawn
               }
             })
    end

    before do
      array = Array.new(8) { Array.new(8, '') }
      chess_board.instance_variable_set(:@board, array)
      chess_board.instance_variable_set(:@chess_pieces, chess_pieces)
      allow(chess_board).to receive(:add_pieces)
    end

    it 'will call #add_pieces exactly 12 times to add white and black pieces' do
      expect(chess_board).to receive(:add_pieces).exactly(12).times
      chess_board.set_up_pieces
    end
  end

  # describe '#add_pieces' do
  #   subject(:chess_board) { described_class.new }

  #   it 'will add white rook pieces' do
  #     key = "\u2656"
  #     positions = [[7, 0], [7, 7]]
  #     board = Array.new(8) { Array.new(8, '') }

  #     expect { chess_board.add_pieces(board, key, positions) }.to change { board[7][0] }.from('').to(key)
  #   end

  #   it 'will add black pawn pieces' do
  #     key = "\u265F"
  #     positions = (0..7).map { |col| [1, col] }
  #     board = Array.new(8) { Array.new(8, '') }

  #     expect { chess_board.add_pieces(board, key, positions) }.to change { board[1][0] }.from('').to(key)
  #   end
  # end

  describe '#update_board' do
  end
end
