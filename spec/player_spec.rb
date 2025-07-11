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
      end

      it 'it will return an array with 2 elements' do
        player_input = player_move.validate_player_move.length

        expect(player_input).to eql(2)
      end

      it 'will contain letters between a to h' do
        player_input = player_move.validate_player_move

        expect(player_input).to all(match(/[a-h]/))
      end

      it 'will have numbers between 1-8' do
        player_input = player_move.validate_player_move

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
      end

      it 'will keep asking the player input until input is valid' do
        expect(player_move).to receive(:gets).exactly(4).times
        player_move.validate_player_move
      end
    end
  end

  # describe '#check_input?' do
  #   subject(:)
  # end
end
