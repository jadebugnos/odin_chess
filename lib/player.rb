class Player
  attr_accessor :name, :color

  def initialize(name = nil, color = nil)
    @name = name
    @color = color
  end

  # Main method to validate a player's move (expects 2 valid inputs)
  def validate_player_move
    move = []
    loop do
      print_move_stage(move.length) # Prompt based on input stage
      input = gets.chomp.strip.downcase

      move << input if check_input?(input) # Only accept valid inputs
      break if move.length == 2 # Expecting 2 steps: from → to
    end

    move
  end

  # Show different messages depending on input stage
  def print_move_stage(move)
    if move.zero?
      puts 'Select a piece to move: '
    else
      puts 'select a cell to move: '
    end
  end

  # validates player input
  def check_input?(input)
    unless input.length == 2
      puts 'only accepts 1 number between 1-8 and a letter a-h'
      return false
    end

    num = input[0]
    letter = input[1]

    check_num_and_letter?(num, letter)
  end

  # Check if input is within valid board coordinates
  def check_num_and_letter?(num, str)
    return true if ('1'..'8').include?(num) &&
                   ('a'..'h').include?(str)

    puts 'Invalid input! Try Again'
    false
  end

  # Ask the player to input and confirm their name
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

  # Ask the player to choose their color (black or white)
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

  # Wrapper method that handles both name and color assignment
  def handle_name_and_color(color = nil)
    print_turn_message(color) # Show message if player 2
    assign_name               # Ask for and confirm name
    assign_color(color)       # Assign or ask for color
  end

  private

  # Delegates to ask_assign_names
  def assign_name
    ask_assign_names
  end

  # Print message for player 2
  def print_turn_message(color)
    puts 'Player 2 next. ' unless color.nil?
  end

  # Assigns the opposite color if already chosen, otherwise prompts
  def assign_color(color)
    valid_colors = %i[black white]
    black, white = valid_colors

    if valid_colors.include?(color)
      @color = color == black ? white : black
      puts "player 2's color will be #{@color}"
    else
      ask_assign_colors
    end
  end
end
