require_relative '../lib/input_helper'
require_relative '../lib/serializable'

# Represents a chess player with name and color attributes.
#
# Handles input validation, assigning player names/colors,
# and special commands like saving or resigning.
class Player # rubocop:disable Metrics/ClassLength
  attr_accessor :name, :color

  include InputHelper
  include Serializable

  # Initializes a player.
  #
  # @param name [String, nil] Player's name.
  # @param color [Symbol, nil] Player's color (:black or :white).
  def initialize(name = nil, color = nil)
    @name = name
    @color = color
  end

  # Validates a player's move by collecting two valid inputs.
  #
  # Prompts for the starting square and the destination square,
  # allowing special commands ('save', 'exit').
  #
  # @param game_state [Object, nil] Current game state (for save/exit).
  # @return [Array<String>] Array of two validated inputs [from, to].
  def validate_player_move(game_state = nil)
    move = []
    loop do
      print_move_stage(move.length)
      input = gets.chomp.strip.downcase

      if %w[save exit].include?(input)
        handle_save_exit(game_state, input)
        next
      end

      move << input if check_input?(input)
      break if move.length == 2
    end

    convert_input(move)
  end

  # Handles save or exit commands.
  #
  # @param game_state [Object] Current game state.
  # @param input [String] Either 'save' or 'exit'.
  def handle_save_exit(game_state, input)
    save_game_state(game_state) if input == 'save'
    handle_resignation(game_state) if input == 'exit'
  end

  # Handles resignation (exit command).
  #
  # @param _game_state [Object, nil] Current game state (unused).
  def handle_resignation(_game_state = nil)
    puts 'Are you sure you want to quit?(y/n)'

    return unless handle_validation == 'y'

    exit(0)
  end

  # Checks if input is valid chessboard notation.
  #
  # @param input [String] Player's raw input.
  # @return [Boolean] true if valid, false otherwise.
  def check_input?(input)
    unless input.length == 2
      puts '[Invalid] only accepts 1 number between 1-8 and a letter a-h'
      return false
    end

    letter = input[0]
    num = input[1]

    check_letter_and_num?(letter, num)
  end

  # Validates that input corresponds to a valid board coordinate.
  #
  # @param str [String] File (a–h).
  # @param num [String] Rank (1–8).
  # @return [Boolean] true if valid coordinate, false otherwise.
  def check_letter_and_num?(str, num)
    return true if ('1'..'8').include?(num) &&
                   ('a'..'h').include?(str)

    puts 'Invalid input! Try Again'
    false
  end

  # Prompts the player to enter and confirm their name.
  #
  # @return [void]
  def ask_assign_names
    answer = nil
    name = nil

    loop do
      name = prompt_for_name
      answer = prompt_to_save_name(name)
      break if answer == 'y'
    end
  end

  # Prompts the player to choose their color (black or white).
  #
  # @return [void]
  def ask_assign_colors
    color = nil
    color_is_valid = nil

    until color_is_valid
      color, color_is_valid = prompt_for_color
      print_color_validity(color_is_valid, color)
    end

    @color = color.to_sym
  end

  # Handles both name and color assignment.
  #
  # @param color [Symbol, nil] Preassigned color (:black or :white).
  # @return [void]
  def handle_name_and_color(color = nil)
    print_turn_message(color)
    assign_name
    assign_color(color)
  end

  private

  # Prompts for player's name.
  #
  # @return [String] The entered name.
  def prompt_for_name
    puts 'what is your name? '
    gets.chomp.strip
  end

  # Confirms with the player whether to save the chosen name.
  #
  # @param name [String] Proposed player name.
  # @return [String] 'y' if confirmed, otherwise 'n'.
  def prompt_to_save_name(name)
    puts "are you sure you want to use #{name}?(y/n)"

    answer = gets.chomp.strip.downcase

    if answer == 'y'
      puts 'saving name...'
      @name = name
      puts 'name saved successfully.'
    else
      puts "#{name} was not saved. repeating process..."
    end

    answer
  end

  # Prompts the player to choose a color.
  #
  # @return [Array<(String, Boolean)>] Color input and validity.
  def prompt_for_color
    valid_colors = %w[black white]

    puts 'What color do you want to play?(black/white)'

    color = gets.chomp.strip.downcase

    [color, valid_colors.include?(color)]
  end

  # Prints stage-specific prompts for move input.
  #
  # @param move_count [Integer] Current stage (0 for from, 1 for to).
  # @return [void]
  def print_move_stage(move_count)
    puts "\n[Commands: type 'save' to save, 'exit' to quit]\n"
    puts "#{@name}'s turn. your color is #{@color}."
    if move_count.zero?
      puts "Select a piece to move (e.g., 'a2'), then press Enter:"
    else
      puts "Enter the destination square (e.g., 'a4'), then press Enter:"
    end
  end

  # Prints whether a chosen color is valid.
  #
  # @param color_is_valid [Boolean] Whether the input is valid.
  # @param color [String] Entered color.
  # @return [void]
  def print_color_validity(color_is_valid, color)
    if color_is_valid
      puts "your color is #{color}"
    else
      puts 'Invalid input! Try again.'
    end
  end

  # Delegates to ask_assign_names.
  #
  # @return [void]
  def assign_name
    ask_assign_names
  end

  # Prints message for player 2 when assigning name/color.
  #
  # @param color [Symbol, nil] Preassigned color.
  # @return [void]
  def print_turn_message(color)
    puts 'Player 2 next. ' unless color.nil?
  end

  # Assigns color to player.
  #
  # If one color is already chosen, assigns the opposite.
  # Otherwise prompts for color choice.
  #
  # @param color [Symbol, nil] Preassigned color (:black or :white).
  # @return [void]
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
