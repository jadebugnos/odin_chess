require 'yaml'

module Serializable
  SAVE_DIR = File.expand_path('../saves', __dir__).freeze

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

  def save_game(state, filename)
    filepath = File.join(Serializable::SAVE_DIR, filename)
    str_obj = YAML.dump(state)
    File.write(filepath, str_obj)
  end

  def handle_load_game
    files = Dir.children(SAVE_DIR)

    return if files.empty?

    puts 'Do you want to load a saved game?'

    return load_game if handle_validation == 'y'

    puts 'Creating new game...'
  end

  def load_game
    file_name = handle_file_name
    load_file(file_name) unless file_name.nil?
  end

  def handle_file_name
    files = Dir.children(SAVE_DIR)

    puts 'Saved games:'
    files.each { |file| puts "- #{file}" }
    fetch_file_name
  end

  def fetch_file_name
    loop do
      print 'Enter file name or type exit: '
      file_name = gets.chomp.strip

      return if file_name == 'exit'

      filepath = File.join(SAVE_DIR, file_name)

      return filepath if File.exist?(filepath)

      puts "file name doesn't exist!"
    end
  end

  def load_file(filepath)
    if File.exist?(filepath)
      permitted = [ChessGame, ChessBoard, ChessPiece] + ObjectSpace.each_object(Class).select { |c| c < ChessPiece }

      YAML.safe_load_file(filepath, permitted_classes: permitted)
    else
      self
    end
  end
end

# require_relative 'board'
# require_relative 'game'

# dummy_game = Class.new do
#   include Serializable
# end.new

# board = ChessBoard.new
# game = ChessGame.new(board)
# filename = 'jade.yml'
# dummy_game.save_game(game, filename)

# loaded = dummy_game.handle_load_game

# (loaded || game).play_game
