require_relative '../lib/move_validator'
RSpec.describe MoveValidator do
  let(:dummy_class) do
    Class.new do
      include Validations
    end.new
  end

  describe '#check_input_format?' do
  end

  describe '#empty_cell?' do
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
