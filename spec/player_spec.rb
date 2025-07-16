require_relative '../lib/player'

RSpec.describe Player do
  describe '#validate_player_move' do
    subject(:player_move) { described_class.new }

    context 'if the player input is valid' do
      before do
        first = '1a'
        second = '4a'
        allow(player_move).to receive(:gets).and_return(first, second)
        allow(player_move).to receive(:check_input?).and_return(true, true)
        allow(player_move).to receive(:print_move_stage)
      end

      let(:player_input) { player_move.validate_player_move }

      it 'it will return an array with 2 elements' do
        result = %w[1a 4a]

        expect(player_input).to eql(result)
      end

      it 'will contain letters between a to h' do
        expect(player_input).to all(match(/[a-h]/))
      end

      it 'will have numbers between 1-8' do
        expect(player_input).to all(match(/\A[1-8]/))
      end
    end

    context 'if the player input is invalid' do
      before do
        first_invalid = '#i'
        second_invalid = '99'
        first_valid = '1a'
        second_valid = '4a'
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
        allow(player_input).to receive(:check_num_and_letter?)
        allow(player_input).to receive(:puts)
      end
      it 'will return false' do
        input = '11a'
        length_is_not_two = player_input.check_input?(input)

        expect(length_is_not_two).to eq(false)
      end
    end

    context 'when the input length is exactly 2' do
      it 'will continue the execution and call check_num_and_letter' do
        input = '1a'

        expect(player_input).to receive(:check_num_and_letter?).with('1', 'a')
        player_input.check_input?(input)
      end

      it 'will return true if input pass the validation' do
        allow(player_input).to receive(:check_num_and_letter?).and_return(true)
        input = '3g'
        valid_input = player_input.check_input?(input)

        expect(valid_input).to eq(true)
      end
    end
  end

  describe '#check_num_and_letter?' do
    context 'when the num and letter arguments are valid' do
      subject(:valid_player_input) { described_class.new }
      before do
        allow(valid_player_input).to receive(:puts)
      end

      it 'will return true' do
        num = '8'
        letter = 'h'
        valid_arguments = valid_player_input.check_num_and_letter?(num, letter)

        expect(valid_arguments).to eq(true)
      end
    end

    context 'when the num argument is invalid' do
      subject(:invalid_arguments) { described_class.new }
      before do
        allow(invalid_arguments).to receive(:puts)
      end
      it 'will return false if non numeric character' do
        num = '#'
        letter = 'h'
        none_num_arg = invalid_arguments.check_num_and_letter?(num, letter)

        expect(none_num_arg).to eq(false)
      end

      it 'will return false if num is out of range' do
        num = '23'
        letter = 'c'
        num_out_of_range = invalid_arguments.check_num_and_letter?(num, letter)

        expect(num_out_of_range).to eq(false)
      end

      it 'will return false if letter is non letter' do
        num = '4'
        letter = '$'
        non_letter_arg = invalid_arguments.check_num_and_letter?(num, letter)

        expect(non_letter_arg).to eq(false)
      end

      it 'will return false if letter is out of rage (a-h)' do
        num = '5'
        letter = 'k'
        out_of_range_char = invalid_arguments.check_num_and_letter?(num, letter)

        expect(out_of_range_char).to eq(false)
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

  describe '#ask_assign-colors' do
  end
end
