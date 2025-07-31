require_relative '../lib/checkmate_finder'

RSpec.describe CheckmateFinder do
  let(:checkmate_finder) do
    Class.new do
      include CheckmateFinder
    end.new
  end

  describe '#directional_search?' do
    context 'when the next cell on the same direction contains enemy piece' do
      let(:board) { Array.new(8) { Array.new(8, '') } }

      before do
        board[0][7] = '♜'
      end
      it 'will return true' do
        color = :white
        king_loc = [0, 3]
        delta = [
          [-1, 0],  # up
          [1, 0],   # down
          [0, -1],  # left
          [0, 1]    # right
        ]
        direction = :linear
        threat_found = checkmate_finder.directional_search?(color, board, king_loc, delta, direction)

        expect(threat_found).to eq(true)
      end
    end

    context 'when no threat is found' do
      let(:board) { Array.new(8) { Array.new(8, '') } }
      it 'returns false' do
        color = :white
        king_loc = [0, 3]
        delta = [
          [-1, 0],  # up
          [1, 0],   # down
          [0, -1],  # left
          [0, 1]    # right
        ]
        direction = :linear
        threat_found = checkmate_finder.directional_search?(color, board, king_loc, delta, direction)

        expect(threat_found).to eq(false)
      end

      context 'when the king is surrounded by allied pieces' do
        let(:chess_board) { Array.new(8) { Array.new(8, '') } }

        before do
          pieces_near_black_king = {
            '♜' => [[0, 3]],
            '♝' => [[0, 5]],
            '♟' => [[1, 3], [1, 4], [1, 5]]
          }

          chess_board[0][4] = '♚' # Place black king
          chess_board[3][7] = '♕' # threat queen at h5

          def add_pieces(board, key, positions)
            positions.each do |x, y|
              board[x][y] = key
            end
          end

          pieces_near_black_king.each do |key, positions|
            add_pieces(chess_board, key, positions)
          end
        end

        it 'returns false' do
          color = :black
          king_loc = [0, 4]
          delta = [
            [-1, -1], [-1, 1],
            [1, -1],  [1, 1]
          ]
          direction = :diagonal
          threat_found = checkmate_finder.directional_search?(color, chess_board, king_loc, delta, direction)

          expect(threat_found).to eq(false)
        end
      end

      context 'when the white king is surrounded by allied pieces' do
        let(:chess_board) { Array.new(8) { Array.new(8, '') } }

        before do
          pieces_near_white_king = {
            '♖' => [[7, 3]], # white rook on the left
            '♗' => [[7, 5]], # white bishop on the right
            '♙' => [[6, 3], [6, 4], [6, 5]] # white pawns in front
          }

          chess_board[7][4] = '♔' # Place white king at e1
          chess_board[4][1] = '♛' # black queen on b4 (not actually a threat due to allies)

          def add_pieces(board, key, positions)
            positions.each do |x, y|
              board[x][y] = key
            end
          end

          pieces_near_white_king.each do |key, positions|
            add_pieces(chess_board, key, positions)
          end
        end

        it 'returns false' do
          color = :white
          king_loc = [7, 4]
          delta = [
            [-1, -1], [-1, 1],
            [1, -1],  [1, 1]
          ]
          direction = :diagonal
          threat_found = checkmate_finder.directional_search?(color, chess_board, king_loc, delta, direction)

          expect(threat_found).to eq(false)
        end
      end
    end

    context 'when the direction is diagonal' do
      let(:board) { Array.new(8) { Array.new(8, '') } }

      it 'returns true if it finds a enemy bishop' do
        color = :white
        board[6][7] = '♝' # black bishop at h2
        king_loc = [1, 2] # king's coordinates at c7
        delta = [
          [-1, -1], [-1, 1],
          [1, -1],  [1, 1]
        ]
        direction = :diagonal
        diagonal_threat_found = checkmate_finder.directional_search?(color, board, king_loc, delta, direction)

        expect(diagonal_threat_found).to eq(true)
      end

      it 'returns true if it finds a enemy queen' do
        color = :black
        board[7][0] = '♕' # white queen at a1
        king_coordinates = [0, 7] # king at h8
        delta = [
          [-1, -1], [-1, 1],
          [1, -1],  [1, 1]
        ]
        direction = :diagonal
        diagonal_threat_found = checkmate_finder.directional_search?(color, board, king_coordinates, delta, direction)

        expect(diagonal_threat_found).to eq(true)
      end
    end

    context 'when enemy is further down the line' do
      it 'returns true if enemy rook is 3 squares away with no obstruction' do
        board = Array.new(8) { Array.new(8, '') }
        board[0][7] = '♜' # rook at h8
        color = :white
        king_loc = [0, 3] # king at d8
        delta = [[0, 1]] # right only
        direction = :linear

        result = checkmate_finder.directional_search?(color, board, king_loc, delta, direction)
        expect(result).to eq(true)
      end
    end

    context 'when the threat is blocked by an ally' do
      it 'returns false if enemy bishop is blocked by ally' do
        board = Array.new(8) { Array.new(8, '') }
        board[3][3] = '♝' # black bishop
        board[2][2] = '♙' # white pawn blocks
        king_loc = [1, 1]
        color = :white
        delta = [[1, 1]]
        direction = :diagonal

        expect(
          checkmate_finder.directional_search?(color, board, king_loc, delta, direction)
        ).to eq(false)
      end

      context 'when threat is blocked by enemy' do
        it 'returns false if enemy bishop is blocked by another enemy' do
          board = Array.new(8) { Array.new(8, '') }
          board[2][2] = '♟' # enemy pawn blocks
          board[3][3] = '♝' # enemy bishop
          king_loc = [1, 1]
          color = :white
          delta = [[1, 1]]
          direction = :diagonal

          expect(
            checkmate_finder.directional_search?(color, board, king_loc, delta, direction)
          ).to eq(false)
        end
      end
    end
  end
end
