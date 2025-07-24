require_relative '../lib/pieces'

RSpec.describe ChessPiece do
  describe '#legal_move?' do
    let(:empty_row) { Array.new(8, '') }
    let(:empty_board) { Array.new(8) { empty_row.dup } }

    context 'when piece uses fixed delta (e.g., knight)' do
      let(:knight_unicode) { '♘' }
      let(:knight_moves) do
        [[-2, -1], [-2, 1], [-1, -2], [-1, 2],
         [1, -2], [1, 2], [2, -1], [2, 1]]
      end

      let(:knight) { ChessPiece.new(knight_unicode, knight_moves) }

      it 'returns true for a valid knight move' do
        board = Marshal.load(Marshal.dump(empty_board))
        board[4][4] = knight_unicode
        move = [[4, 4], [2, 5]] # delta = [-2, 1]
        expect(knight.legal_move?(move, board)).to be true
      end

      it 'returns false for an invalid knight move' do
        board = Marshal.load(Marshal.dump(empty_board))
        board[4][4] = knight_unicode
        move = [[4, 4], [3, 4]] # delta = [-1, 0]
        expect(knight.legal_move?(move, board)).to be false
      end
    end

    context 'when piece uses directions (e.g., rook)' do
      let(:rook_unicode) { '♖' }
      let(:rook_directions) { [[-1, 0], [1, 0], [0, -1], [0, 1]] }
      let(:rook) { ChessPiece.new(rook_unicode, nil, rook_directions) }

      it 'returns true for an unobstructed vertical move' do
        board = Marshal.load(Marshal.dump(empty_board))
        board[0][0] = rook_unicode
        move = [[0, 0], [3, 0]] # delta = [1, 0]
        expect(rook.legal_move?(move, board)).to be true
      end

      it 'returns false for an obstructed vertical move' do
        board = Marshal.load(Marshal.dump(empty_board))
        board[0][0] = rook_unicode
        board[2][0] = '♙'
        move = [[0, 0], [3, 0]] # blocked by pawn at [2, 0]
        expect(rook.legal_move?(move, board)).to be false
      end

      it 'returns false for a diagonal move' do
        board = Marshal.load(Marshal.dump(empty_board))
        board[0][0] = rook_unicode
        move = [[0, 0], [1, 1]] # delta = [1, 1]
        expect(rook.legal_move?(move, board)).to be false
      end
    end
  end
end
