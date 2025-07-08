require_relative '../lib/board'

RSpec.describe ChessBoard do
  describe '#create_board' do
    subject(:game_board) { described_class.new }
    before do
      game_board.instance_variable_set(:@board, nil)
    end

    context 'when @board is nil' do
      it 'will create a 8x8 2D array' do
        board = Array.new(8) { Array.new(8, '|  |') }
        created_board = game_board.create_board

        expect(created_board).to eql(board)
      end

      it 'will assign the newly created board to @board' do
        board = Array.new(8) { Array.new(8, '|  |') }
        expect { game_board.create_board }.to change { game_board.instance_variable_get(:@board) }.from(nil).to(board)
      end
    end
  end

  describe '#add_designs' do
  end

  describe '#add_pieces' do
  end

  describe '#display_board' do
  end

  describe '#update_board' do
  end
end
