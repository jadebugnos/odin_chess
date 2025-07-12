class Player # rubocop:disable Style/Documentation
  def validate_player_move
    move = []
    loop do
      print_move_stage(move.length)
      input = gets.chomp.strip.downcase

      move << input if check_input?(input) # helper method to check input validity
      break if move.length == 2
    end

    move
  end

  def print_move_stage(move)
    if move.zero?
      puts 'Select a piece to move: '
    else
      puts 'select a cell to move: '
    end
  end

  def check_input?(input)
    unless input.length == 2
      puts 'only accepts 1 number between 1-8 and a letter a-h'
      return false
    end

    num = input[0]
    letter = input[1]

    check_num_and_letter?(num, letter)
  end

  def check_num_and_letter?(num, str)
    return true if ('1'..'8').include?(num) &&
                   ('a'..'h').include?(str)

    puts 'Invalid input! Try Again'
    false
  end
end
