require_relative '../lib/move_validator'

RSpec.describe MoveValidator do
  let(:validator) do
    Class.new do
      include MoveValidator
    end.new
  end

  describe '#check_input_format?' do
    context 'when the input format is correct' do
      it 'will return true for valid pawn move' do
        pawn_move = [[6, 4], [4, 4]] # e2 to e4
        correct_format = validator.check_input_format?(pawn_move)

        expect(correct_format).to eq(true)
      end

      it 'will return true for valid Knight move' do
        knight_move = [[7, 6], [5, 5]]  # g1 to f3
        correct_format = validator.check_input_format?(knight_move)

        expect(correct_format).to eq(true)
      end

      it 'will return true for valid bishop move' do
        bishop_move = [[7, 5], [3, 1]]  # f1 to b5
        correct_format = validator.check_input_format?(bishop_move)

        expect(correct_format).to eq(true)
      end
    end

    context 'when the input format is incorrect' do
      it 'will return false' do
        invalid_input = [[6, 10], [4, 10]] # invalid columns (outside 0-7)
        incorrect_format = validator.check_input_format?(invalid_input)

        expect(incorrect_format).to eq(false)
      end

      it 'will return false if theres a nil value' do
        invalid_input = [nil, nil]
        nil_input = validator.check_input_format?(invalid_input)

        expect(nil_input).to eq(false)
      end

      it 'will return false if the values are out of range' do
        invalid_input = [[-1, 0], [8, 9]] # out of board bounds
        out_of_bounds = validator.check_input_format?(invalid_input)

        expect(out_of_bounds).to eq(false)
      end
    end
  end

  describe '#occupied_source_cell?' do
    context 'when the source square is occupied' do
      let(:board) { Array.new(8) { Array.new(8, '') } }

      before do
        board[7][0] = "\u2656" # rook at a1
        board[7][1] = "\u2658" # knight at b1
        board[7][3] = "\u2655" # queen at d1
      end
      it 'will return true' do
        input = [[7, 0], [7, 1]]
        cell_is_occupied = validator.occupied_source_cell?(board, input)

        expect(cell_is_occupied).to eq(true)
      end

      it 'will return true for knight position' do
        input = [[7, 1], [7, 6]]
        cell_is_occupied = validator.occupied_source_cell?(board, input)

        expect(cell_is_occupied).to eq(true)
      end

      it 'will return true for queen position' do
        input = [[7, 3], [7, 6]]
        cell_is_occupied = validator.occupied_source_cell?(board, input)

        expect(cell_is_occupied).to eq(true)
      end
    end

    context 'when the source square is empty' do
      let(:board) { Array.new(8) { Array.new(8, '') } }

      it 'will return false' do
        input = [[7, 0], [7, 1]]
        cell_is_empty = validator.occupied_source_cell?(board, input)

        expect(cell_is_empty).to eq(false)
      end

      it 'will return false on other empty cell' do
        input = [[0, 0], [0, 7]]
        cell_is_empty = validator.occupied_source_cell?(board, input)

        expect(cell_is_empty).to eq(false)
      end

      it 'will return false on any empty inbound cell' do
        input = [[0, 2], [0, 5]]
        cell_is_empty = validator.occupied_source_cell?(board, input)

        expect(cell_is_empty).to eq(false)
      end
    end
  end

  describe '#check_players_turn?' do
    context "when it is the current player's turn" do
      let(:board) { Array.new(8) { Array.new(8, '') } }
      before do
        board[7][0] = "\u2656"
        board[0][0] = "\u265C"
      end

      it 'will return true' do
        input = [[7, 0], [0, 0]]
        turn = :white
        current_player = validator.check_players_turn?(turn, input, board)

        expect(current_player).to eq(true)
      end

      it 'returns true for black pieces' do
        input = [[0, 0], [0, 7]]
        turn = :black
        current_player = validator.check_players_turn?(turn, input, board)

        expect(current_player).to eq(true)
      end
    end

    context "when it is not the current player's turn" do
      let(:board) { Array.new(8) { Array.new(8, '') } }
      before do
        board[7][0] = "\u2656"
        board[0][2] = "\u265D"
      end

      it 'will return false if black player moves white pieces' do
        input = [[7, 0], [7, 7]]
        turn = :black
        current_player = validator.check_players_turn?(turn, input, board)

        expect(current_player).to eq(false)
      end

      it 'will return false of white player moves black pieces' do
        input = [[0, 2], [0, 5]]
        turn = :white
        current_player = validator.check_players_turn?(turn, input, board)

        expect(current_player).to eq(false)
      end
    end
  end

  describe 'check_piece_legal_move?' do
    context 'when the chosen piece allows the move' do
      let(:board) { Array.new(8) { Array.new(8, '') } }

      before do
        board[6][4] = "\u2659" # White pawn at e2

        piece = PieceIndex::PIECE_HASH[:white]["\u2659"]
        allow(piece).to receive(:legal_move?)
          .with([[6, 4], [4, 4]], board, :white)
          .and_return(true)
      end

      it 'returns true' do
        color = :white
        player_move = [[6, 4], [4, 4]] # white pawn e2 → e4
        legal_move = validator.check_piece_legal_move?(color, player_move, board)

        expect(legal_move).to eq(true)
      end
    end

    context "when the chosen piece doesn't allow the move" do
      let(:board) { Array.new(8) { Array.new(8, '') } }

      before do
        board[7][0] = "\u2656" # White rook at a1

        piece = PieceIndex::PIECE_HASH[:white]["\u2656"]
        allow(piece).to receive(:legal_move?)
          .with([[7, 0], [6, 1]], board, :white)
          .and_return(false)
      end

      it 'returns false' do
        color = :white
        player_move = [[7, 0], [6, 1]] # a1 → b2 (illegal for rook)
        illegal_move = validator.check_piece_legal_move?(color, player_move, board)

        expect(illegal_move).to eq(false)
      end
    end
  end

  describe 'empty_destination?' do
    context 'when the destination cell is empty' do
      let(:board) { Array.new(8) { Array.new(8, '') } }

      it 'will return true' do
        player_move = [[0, 5], [3, 2]] # black bishop f8 → c5
        color = :black
        empty_cell = validator.empty_destination?(player_move, board, color)

        expect(empty_cell).to eq(true)
      end
    end

    context 'when the destination cell is not empty' do
      let(:board) { Array.new(8) { Array.new(8, '') } }
      before do
        board[3][2] = "\u265C"
      end

      it "will return false if the cell contain's piece with same color" do
        player_move = [[0, 5], [3, 2]] # black bishop f8 → c5
        color = :black
        empty_cell = validator.empty_destination?(player_move, board, color)

        expect(empty_cell).to eq(false)
      end
    end

    context 'when the destination cell has an enemy piece' do
      let(:board) { Array.new(8) { Array.new(8, '') } }
      before do
        board[3][2] = "\u2659" # white pawn
      end

      it 'returns true (can capture enemy piece)' do
        player_move = [[0, 5], [3, 2]] # black bishop f8 → c5
        color = :black
        result = validator.empty_destination?(player_move, board, color)

        expect(result).to eq(true)
      end
    end

    context 'when the destination is at the edge of the board' do
      let(:board) { Array.new(8) { Array.new(8, '') } }

      it 'returns true if the destination cell is empty' do
        player_move = [[6, 7], [7, 7]] # e.g. pawn promotion
        color = :white
        result = validator.empty_destination?(player_move, board, color)

        expect(result).to eq(true)
      end
    end

    context 'when the destination is at position [0, 0]' do
      let(:board) { Array.new(8) { Array.new(8, '') } }

      it 'returns true if cell is empty' do
        player_move = [[1, 0], [0, 0]]
        color = :white
        result = validator.empty_destination?(player_move, board, color)

        expect(result).to eq(true)
      end
    end

    context 'when a pawn moves forward into an empty square' do
      let(:board) { Array.new(8) { Array.new(8, '') } }

      it 'returns true' do
        player_move = [[6, 4], [5, 4]] # white pawn e2 → e3
        color = :white
        result = validator.empty_destination?(player_move, board, color)

        expect(result).to eq(true)
      end
    end

    context 'when a pawn moves forward into an enemy piece' do
      let(:board) { Array.new(8) { Array.new(8, '') } }

      before do
        board[5][4] = "\u265C" # black rook
      end

      it 'returns false (pawns can’t capture forward)' do
        player_move = [[6, 4], [5, 4]] # white pawn e2 → e3
        color = :white
        result = validator.empty_destination?(player_move, board, color)

        expect(result).to eq(false)
      end
    end

    context 'when a pawn captures diagonally into an enemy piece' do
      let(:board) { Array.new(8) { Array.new(8, '') } }

      before do
        board[5][5] = "\u265C" # black rook
      end

      it 'returns true (diagonal capture)' do
        player_move = [[6, 4], [5, 5]] # white pawn e2 → f3
        color = :white
        result = validator.empty_destination?(player_move, board, color)

        expect(result).to eq(true)
      end
    end
  end

  context 'when a pawn moves diagonally into an empty square' do
    let(:board) { Array.new(8) { Array.new(8, '') } }

    it 'returns false (no capture possible)' do
      player_move = [[6, 4], [5, 5]] # white pawn e2 → f3
      color = :white
      result = validator.empty_destination?(player_move, board, color)

      expect(result).to eq(false)
    end
  end
end
