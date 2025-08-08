require_relative '../lib/checkmate_finder'

RSpec.describe CheckmateFinder do
  let(:checkmate_finder) do
    Class.new do
      include CheckmateFinder
    end.new
  end

  describe '#checkmate?' do
    context 'when a check has been found' do
      let(:board) { Array.new(8) { Array.new(8, '') } }
      before do
        # Black pieces
        board[0][6] = '♚' # Black King at g8
        board[0][5] = '♜' # Black Rook at f8
        board[1][5] = "\u265F" # Black Pawn at f7
        board[1][7] = "\u265F" # Black Pawn at h7

        # White pieces
        board[1][4] = '♘'  # White Knight at e7
        board[6][1] = '♗'  # White Bishop at b2
        board[7][6] = '♕'  # White Queen at g1
      end
      xit 'returns true' do
        color = :black
        king_position = [0, 6]
        checkmate_found = checkmate_finder.checkmate?(color, board, king_position)

        expect(checkmate_found).to eq(true)
      end
    end
  end

  describe '#escape_search?' do
    context 'when a safe adjacent cell is found' do
      xit 'returns true' do
        color = :white
        board = Array.new(8) { Array.new(8, '') }
        king_position = [0, 0]
        safe_cell_found = checkmate_finder.escape_search?(color, board, king_position)

        expect(safe_cell_found).to eq(true)
      end

      context 'when all adjacent cells are under attack' do
        xit 'returns false' do
          color = :white
          board = Array.new(8) { Array.new(8, '') }
          king_position = [4, 4]
          board[4][4] = '♔'

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
          no_safe_cell = checkmate_finder.escape_search?(color, board, king_position)

          expect(no_safe_cell).to eq(false)
        end
      end
    end
  end

  describe '#threat_blockable?' do
    let(:color) { :white }
    let(:king_pos) { [4, 4] }
    let(:pos) { [0, 4] } # Threat from top (like a queen)
    let(:coordinates) { [[1, 4], [2, 4], [3, 4]] }

    let(:board) do
      Array.new(8) { Array.new(8, nil) }.tap do |b|
        b[4][4] = '♔' # King
        b[0][4] = '♛' # Black queen
        b[2][4] = '♙' # White pawn that can block
      end
    end

    context 'when direction is not linear or diagonal' do
      xit 'returns false' do
        result = checkmate_finder.threat_blockable?(color, board, king_pos, pos, :knight, coordinates)
        expect(result).to be false
      end
    end

    context 'when direction is linear and threat can be blocked' do
      xit 'returns true' do
        allow(checkmate_finder).to receive(:handle_deltas).and_return([1, 0])
        allow(checkmate_finder).to receive(:follow_path).and_return(true)

        result = checkmate_finder.threat_blockable?(color, board, king_pos, pos, :linear, coordinates)
        expect(result).to be true
      end
    end

    context 'when direction is diagonal but threat cannot be blocked' do
      xit 'returns false' do
        allow(checkmate_finder).to receive(:handle_deltas).and_return([1, 1])
        allow(checkmate_finder).to receive(:follow_path).and_return(false)

        result = checkmate_finder.threat_blockable?(color, board, king_pos, pos, :diagonal, coordinates)
        expect(result).to be false
      end
    end
  end

  describe '#follow_path' do
    context 'when an allied piece can block the path' do
      let(:board) { Array.new(8) { Array.new(8, '') } }
      let(:color) { :white }

      before do
        board[0][0] = '♔' # white king at a8
        board[4][4] = '♛' # black queen at e4
        board[1][4] = '♘' # white knight at e7

        allow(checkmate_finder).to receive(:puts)
      end
      it 'returns true' do
        pos = [4, 4]
        coordinates = [[1, 4]]
        delta = [-1, -1]
        king_pos = [0, 0]
        result = checkmate_finder.follow_path(board, color, pos, coordinates, delta, king_pos)

        expect(result).to be true
      end
    end

    context 'when no allied piece ca block the path' do
      let(:board) { Array.new(8) { Array.new(8, '') } }
      let(:color) { :white }
      ignore_puts

      before do
        board[0][0] = '♕' # white king at a8
        board[4][4] = '♛' # black queen at e4
        board[6][4] = '♘' # white knight at e2
        board[6][5] = '♕' # white queen at f2
      end
      it 'returns false' do
        pos = [4, 4]
        coordinates = [[6, 4], [6, 5]]
        delta = [-1, -1]
        king_pos = [0, 0]
        result = checkmate_finder.follow_path(board, color, pos, coordinates, delta, king_pos)

        expect(result).to be false
      end
    end

    context 'when the player is black' do
      let(:board) { Array.new(8) { Array.new(8, '') } }
      let(:color) { :black }
      ignore_puts

      it 'returns true if allied piece can block the path' do
        board[3][3] = '♚' # black king at d5
        board[7][4] = '♜' # black rook at e1
        board[5][5] = '♕' # white queen at f3
        board[1][0] = '♝' # black bishop at a7
        board[3][2] = '♞' # black knight at f7

        pos = [5, 5]
        coordinates = [[7, 4], [1, 0], [3, 2]]
        delta = [-1, -1]
        king_pos = [0, 0]
        result = checkmate_finder.follow_path(board, color, pos, coordinates, delta, king_pos)

        expect(result).to be true
      end

      it 'returns false if allied piece cannot block the path' do
        board[3][3] = '♚' # black king at d5
        board[7][3] = '♜' # black rook at e1
        board[5][5] = '♕' # white queen at f3
        board[1][0] = '♝' # black bishop at a7
        board[3][1] = '♞' # black knight at f7

        pos = [5, 5]
        coordinates = [[7, 3], [1, 0], [3, 1]]
        delta = [-1, -1]
        king_pos = [0, 0]
        result = checkmate_finder.follow_path(board, color, pos, coordinates, delta, king_pos)

        expect(result).to be false
      end
    end
  end
end
