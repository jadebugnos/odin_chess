require_relative '../lib/player'

RSpec.describe Player do
  describe '#validate_player_move' do
    subject(:player_move) { described_class.new }

    context 'if the player input is valid' do
      before do
        first = 'a1'
        second = 'a4'
        allow(player_move).to receive(:gets).and_return(first, second)
        allow(player_move).to receive(:check_input?).and_return(true, true)
        allow(player_move).to receive(:print_move_stage)
      end

      let(:player_input) { player_move.validate_player_move }

      it 'will return an array with 2 elements' do
        result = %w[a1 a4]
        expect(player_input).to eql(result)
      end

      it 'will contain valid chess coordinates with letter first' do
        expect(player_input).to all(match(/\A[a-h][1-8]\z/))
      end
    end

    context 'if the player input is invalid' do
      before do
        first_invalid = '#i'
        second_invalid = '99'
        first_valid = 'a1'
        second_valid = 'a4'
        allow(player_move).to receive(:gets).and_return(first_invalid, second_invalid, first_valid, second_valid)
        allow(player_move).to receive(:check_input?).and_return(false, false, true, true)
        allow(player_move).to receive(:print_move_stage)
      end

      it 'will keep asking the player input until input is valid' do
        expect(player_move).to receive(:gets).exactly(4).times
        player_move.validate_player_move
      end
    end
  end

  describe '#check_input?' do
    subject(:player_input) { described_class.new }

    context 'when the input length is not exactly 2' do
      before do
        allow(player_input).to receive(:check_letter_and_num?)
        allow(player_input).to receive(:puts)
      end

      it 'will return false' do
        input = 'a11'
        length_is_not_two = player_input.check_input?(input)

        expect(length_is_not_two).to eq(false)
      end
    end

    context 'when the input length is exactly 2' do
      it 'will continue the execution and call check_letter_and_num' do
        input = 'a1'

        expect(player_input).to receive(:check_letter_and_num?).with('a', '1')
        player_input.check_input?(input)
      end

      it 'will return true if input passes the validation' do
        allow(player_input).to receive(:check_letter_and_num?).and_return(true)
        input = 'g3'
        valid_input = player_input.check_input?(input)

        expect(valid_input).to eq(true)
      end
    end
  end

  describe '#check_letter_and_num?' do
    subject(:player_input) { described_class.new }

    context 'when the letter and number arguments are valid' do
      before { allow(player_input).to receive(:puts) }

      it 'will return true' do
        letter = 'h'
        num = '8'
        valid_arguments = player_input.check_letter_and_num?(letter, num)

        expect(valid_arguments).to eq(true)
      end
    end

    context 'when arguments are invalid' do
      before { allow(player_input).to receive(:puts) }

      it 'returns false if letter is invalid' do
        letter = '#'
        num = '4'
        result = player_input.check_letter_and_num?(letter, num)
        expect(result).to eq(false)
      end

      it 'returns false if letter is out of range' do
        letter = 'k'
        num = '5'
        result = player_input.check_letter_and_num?(letter, num)
        expect(result).to eq(false)
      end

      it 'returns false if num is invalid' do
        letter = 'c'
        num = '$'
        result = player_input.check_letter_and_num?(letter, num)
        expect(result).to eq(false)
      end

      it 'returns false if num is out of range' do
        letter = 'b'
        num = '9'
        result = player_input.check_letter_and_num?(letter, num)
        expect(result).to eq(false)
      end
    end
  end

  describe '#ask_assign_names' do
    subject(:player_name) { described_class.new }

    context 'when the player is sure with the name' do
      before do
        allow(player_name).to receive(:gets).and_return('Jade', 'y')
        allow(player_name).to receive(:puts)
      end

      it "will save the player's name to @name" do
        expect { player_name.ask_assign_names }.to change { player_name.name }.from(nil).to('Jade')
      end
    end

    context 'when the player is not sure with the name' do
      before do
        allow(player_name).to receive(:gets).and_return('Jade', 'n', 'Jones', 'y')
        allow(player_name).to receive(:puts)
      end

      it 'will ask the player again for the name in the terminal' do
        expect { player_name.ask_assign_names }.to change { player_name.name }.from(nil).to('Jones')
      end
    end
  end

  describe '#ask_assign_colors' do
    subject(:player_color) { described_class.new }

    context 'when player inputs a correct color' do
      before { allow(player_color).to receive(:puts) }

      it 'assigns :black if input is "black"' do
        allow(player_color).to receive(:gets).and_return('black')
        expect { player_color.ask_assign_colors }.to change { player_color.color }.from(nil).to(:black)
      end

      it 'assigns :white if input is "white"' do
        allow(player_color).to receive(:gets).and_return('white')
        expect { player_color.ask_assign_colors }.to change { player_color.color }.from(nil).to(:white)
      end
    end

    context 'when the input is invalid' do
      before { allow(player_color).to receive(:puts) }

      it 'keeps asking until it gets valid input' do
        allow(player_color).to receive(:gets).and_return('sdf', '123', 'w', 'white')
        expect { player_color.ask_assign_colors }.to change { player_color.color }.from(nil).to(:white)
      end
    end
  end
end
