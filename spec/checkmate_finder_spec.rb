require_relative '../lib/checkmate_finder'

RSpec.describe CheckmateFinder do
  let(:checkmate_finder) do
    Class.new do
      include CheckmateFinder
    end.new
  end

  describe '#diagonal_search?' do
    
  end
end
