require_relative '../lib/chess_pieces/pawn'

RSpec.describe Pawn do
  describe '#pawn_valid_destination?' do
    subject(:pawn_destination) { described_class.new }

    context 'when the move is a normal forward move' do
      it 'will return true if the destination is empty' do
        board = Array.new(8) { Array.new(8, '') }
        move = [[1, 4], [2, 4]]
        color = :black
        valid_move = pawn_destination.pawn_valid_destination?(move, board, color)

        expect(valid_move).to eq(true)
      end

      it 'will return false if the destination cell has any piece (even enemy)' do
        board = Array.new(8) { Array.new(8, '') }
        board[2][4] = '♙' # white pawn (enemy) on destination
        move = [[1, 4], [2, 4]] # black pawn moving forward one square
        color = :black
        invalid_move = pawn_destination.pawn_valid_destination?(move, board, color)

        expect(invalid_move).to eq(false)
      end
    end

    context 'when the move is diagonal (capture move):' do
      it 'will return true if the destination cell contains an enemy piece' do
        board = Array.new(8) { Array.new(8, '') }
        board[2][3] = '♙' # white pawn (enemy)
        move = [[1, 4], [2, 3]] # black pawn capturing diagonally
        color = :black
        valid_move = pawn_destination.pawn_valid_destination?(move, board, color)

        expect(valid_move).to eq(true)
      end

      it 'will return false if the destination cell is empty or has same-color piece' do
        board = Array.new(8) { Array.new(8, '') }
        move = [[1, 4], [2, 3]] # black pawn attempting diagonal move
        color = :black
        invalid_move_empty = pawn_destination.pawn_valid_destination?(move, board, color)

        board[2][3] = '♟︎' # black pawn (same color)
        invalid_move_same_color = pawn_destination.pawn_valid_destination?(move, board, color)

        expect(invalid_move_empty).to eq(false)
        expect(invalid_move_same_color).to eq(false)
      end
    end

    context 'when the move is diagonal (capture move) and the pawn is white:' do
      it 'will return true if the destination cell contains an enemy piece' do
        board = Array.new(8) { Array.new(8, '') }
        board[5][3] = '♟' # black pawn (enemy)
        move = [[6, 4], [5, 3]] # white pawn capturing diagonally
        color = :white
        valid_move = pawn_destination.pawn_valid_destination?(move, board, color)

        expect(valid_move).to eq(true)
      end

      it 'will return false if the destination cell is empty or has same-color piece' do
        board = Array.new(8) { Array.new(8, '') }
        move = [[6, 4], [5, 3]] # white pawn attempting diagonal move
        color = :white
        invalid_move_empty = pawn_destination.pawn_valid_destination?(move, board, color)

        board[5][3] = '♙' # white pawn (same color)
        invalid_move_same_color = pawn_destination.pawn_valid_destination?(move, board, color)

        expect(invalid_move_empty).to eq(false)
        expect(invalid_move_same_color).to eq(false)
      end
    end
  end
end
