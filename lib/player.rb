class Player
  attr_accessor :name, :color

  def initialize(name = nil, color = nil)
    @name = name
    @color = color
  end

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

  def ask_assign_names # rubocop:disable Metrics/MethodLength
    answer = nil
    name = nil

    loop do
      puts 'what is your name? '
      name = gets.chomp.strip
      puts "are you sure you want to use #{name}?(y/n)"
      answer = gets.chomp.strip.downcase
      if answer == 'y'
        puts 'saving name...'
        @name = name
        puts 'name saved successfully.'
        break
      else
        puts 'redoing...'
      end
    end
  end

  def ask_assign_colors # rubocop:disable Metrics/MethodLength
    valid_colors = %w[black white]
    color = nil
    color_is_valid = nil

    until color_is_valid
      puts 'What color do you want to play?(black/white)'
      color = gets.chomp.strip.downcase
      color_is_valid = valid_colors.include?(color)

      if color_is_valid
        puts "your color is #{color}"
      else
        puts 'Invalid input! Try again.'
      end
    end

    @color = color.to_sym
  end
end

# player = Player.new
# player.ask_assign_colors
