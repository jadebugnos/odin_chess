require_relative '../lib/player'

RSpec.describe Player do
  describe '#validate_player_move' do
    subject(:player_move) { described_class.new }
    before do
      allow(player_move).to receive(:gets).and_return(%w[2a 4a])
    end

    context 'if the player input is valid' do
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
  end
end
