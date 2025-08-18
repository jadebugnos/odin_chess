module Utility
  # Validates user input to ensure only 'y' or 'n' responses are accepted.
  #
  # Keeps prompting until a valid response is given.
  #
  # @return [String] 'y' or 'n'.
  def handle_validation
    answer = ''

    until %w[y n].include?(answer)
      begin
        answer = gets.chomp.downcase
        raise 'Invalid input! enter y or n' unless %w[y n].include?(answer)
      rescue StandardError => e
        puts e.message
      end
    end

    answer
  end

  # Prints text with a typing animation effect.
  #
  # @param text [String] The text to print.
  # @return [void]
  def slow_print(text)
    text.each_char do |char|
      print char
      sleep(0.01)
    end
    puts
  end
end
