require_relative '../lib/checkmate_finder'

RSpec.describe CheckmateFinder do
  let(:checkmate_finder) do
    Class.new do
      include CheckmateFinder
    end.new
  end

  describe '#checkmate?' do
    context 'when a check has been found' do
      before do
        allow(checkmate_finder).to receive(:check_found?).and_return(true)
      end
      it 'calls checkmate_found?' do
        color = :white
        board = Array.new(8) { Array.new(8, '') }
        king_position = [4, 4]

        expect(checkmate_finder).to receive(:checkmate_found?).once
        checkmate_finder.checkmate?(color, board, king_position)
      end
    end
  end

  describe '#adjacent_cell_search?' do
    context 'when a safe adjacent cell is found' do
      it 'returns true' do
        color = :white
        board = Array.new(8) { Array.new(8, '') }
        king_position = [0, 0]
        safe_cell_found = checkmate_finder.adjacent_cell_search?(color, board, king_position)

        expect(safe_cell_found).to eq(true)
      end

      context 'when all adjacent cells are under attack' do
        it 'returns false' do
          color = :white
          board = Array.new(8) { Array.new(8, '') }
          king_position = [4, 4]
          board[4][4] = '♔'

          # Place black queens to attack all 8 surrounding squares
          # (This is artificial but effective for testing)

          # Attack top-left
          board[2][2] = '♛'
          # Attack top
          board[2][4] = '♛'
          # Attack top-right
          board[2][6] = '♛'
          # Attack right
          board[4][6] = '♛'
          # Attack bottom-right
          board[6][6] = '♛'
          # Attack bottom
          board[6][4] = '♛'
          # Attack bottom-left
          board[6][2] = '♛'
          # Attack left
          board[4][2] = '♛'

          # Now all adjacent squares (3,3), (3,4), (3,5), ..., (5,3) are threatened
          no_safe_cell = checkmate_finder.adjacent_cell_search?(color, board, king_position)

          expect(no_safe_cell).to eq(false)
        end
      end
    end
  end
end
