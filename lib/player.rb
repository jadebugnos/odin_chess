class Player # rubocop:disable Style/Documentation
  def validate_player_move
    move = []
    loop do
      print 'Enter your move (e.g., 2b): '
      input = gets.chomp

      move << input if check_input?(input) # helper method to check input validity
      break if move.length == 2
    end

    move
  end

  def check_input?(input)
    unless input.length == 2
      puts 'only accepts 1 number between 1-8 and a letter a-h'
      return false
    end

    num = input[0]
    letter = input[1]

    check_num(num) && check_letter(letter)
  end

  def check_num(num)
    return true if ('1'..'8').include?(num)

    puts 'invalid input! Enter a valid number'
    false
  end

  def check_letter(str)
    return true if ('a'..'h').include?(str)

    puts 'invalid input! Enter a valid letter'
    false
  end
end

player = Player.new
p player.validate_player_move
