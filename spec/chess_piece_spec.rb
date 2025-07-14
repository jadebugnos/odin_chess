require_relative '../lib/pieces'

RSpec.describe ChessPiece do
  describe '#legal_move?' do
    let(:legal_white_moves) { [[-1, 0], [-1, -1], [-1, 1]] }
    let(:legal_black_moves) { [[1, 0], [1, -1], [1, 1]] }
    subject(:player_move) { described_class.new(nil, legal_white_moves, legal_black_moves) }

    context 'when the move is legal' do
      it 'will return true' do
        color = :white
        move = [[4, 2], [3, 2]]
        legal_move = player_move.legal_move?(color, move)

        expect(legal_move).to eq(true)
      end

      it 'will return false if the move is illegal and the color is black' do
        color = :black
        move = [[4, 6], [5, 7]]
        legal_move = player_move.legal_move?(color, move)

        expect(legal_move).to eq(true)
      end
    end

    context 'when the move is illegal' do
      it 'will return false' do
        color = :white
        move = [[4, 2], [5, 4]]
        illegal_move = player_move.legal_move?(color, move)

        expect(illegal_move).to eq(false)
      end

      it 'will return false if the color is black and the move is illegal' do
        color = :black
        move = [[4, 6], [6, 7]]
        legal_move = player_move.legal_move?(color, move)

        expect(legal_move).to eq(false)
      end
    end
  end
end
