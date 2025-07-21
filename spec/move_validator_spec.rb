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

  describe '#empty_cell?' do
    context 'when the source square has a piece' do
      before do
        let(:board) { double('board', board: Array.new(8) { Array.new(8, '') }) }
        board[7][0] = "\u2656"
      end
      xit 'will return true' do
        []
      end
    end
  end

  describe '#check_players_turn?' do
  end

  describe 'check_piece_legal_move?' do
  end

  describe 'check_clear_path?' do
  end

  describe 'check_destination_cell?' do
  end
end
