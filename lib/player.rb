class Player # rubocop:disable Style/Documentation
  def validate_player_move
    move = []
    loop do
      input = gets.chomp

      move << input if check_input?(input) # helper method to check input validity
      break if move.length == 2
    end

    move
  end

  # def check_input?(input)
  #   num, letter = input.split('')

  #   if (Integer(num)).between?(1, 8)
  #     puts ''
  #   end
  # end
end
