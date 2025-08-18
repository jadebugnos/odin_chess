require 'yaml'
require_relative 'utility'

# Provides functionality for saving and loading game state.
#
# Includes methods for file persistence, serialization, and user input
# validation when saving or loading games.
module Serializable
  include Utility

  # Directory where game save files are stored.
  SAVE_DIR = File.expand_path('../saves', __dir__).freeze

  # Saves the given game state to a YAML file.
  #
  # Prompts the user for a filename, adds `.yml` if missing,
  # and asks for confirmation before saving.
  #
  # @param state [Object] The game state object to save.
  # @return [void]
  def save_game_state(state)
    puts 'Enter file name: '
    filename = gets.chomp.strip

    concatenated = filename.end_with?('.yml') ? filename : "#{filename}.yml"

    puts "Are you sure with #{filename}?(y/n)"

    save_file(state, concatenated) if handle_validation == 'y'
  end

  # Writes the serialized game state to a file.
  #
  # @param state [Object] The game state object.
  # @param filename [String] Name of the file to save.
  # @return [void]
  def save_file(state, filename)
    filepath = File.join(Serializable::SAVE_DIR, filename)
    str_obj = YAML.dump(state)
    File.write(filepath, str_obj)
  end

  # Handles loading a saved game if any exist.
  #
  # Prompts the user to decide whether to load or start a new game.
  #
  # @return [Object, nil] Loaded game object if chosen, otherwise nil.
  def handle_load_game
    files = Dir.children(SAVE_DIR)

    return if files.empty?

    puts 'Do you want to load a saved game?(y/n)'

    return load_game if handle_validation == 'y'

    puts 'Creating new game...'
  end

  # Loads a game by prompting the user for a file.
  #
  # @return [Object, nil] Loaded game object if file chosen, otherwise nil.
  def load_game
    file_name = handle_file_name
    load_file(file_name) unless file_name.nil?
  end

  # Displays saved games and prompts for a filename.
  #
  # @return [String, nil] Chosen filename or nil if none selected.
  def handle_file_name
    files = Dir.children(SAVE_DIR)

    puts 'Saved games:'
    files.each { |file| puts "- #{file}" }
    fetch_file_name
  end

  # Repeatedly prompts the user until a valid filename or 'exit' is given.
  #
  # @return [String, nil] Filepath if valid, or nil if 'exit' chosen.
  def fetch_file_name
    loop do
      print 'Enter file name or type exit: '
      file_name = gets.chomp.strip

      return if file_name == 'exit'

      filepath = File.join(SAVE_DIR, file_name)

      return filepath if File.exist?(filepath)

      puts 'file name not found.'
    end
  end

  # Loads and deserializes a game state from a YAML file.
  #
  # Restricts deserialization to permitted classes.
  #
  # @param filepath [String] Path to the saved game file.
  # @return [Object, nil] The loaded game state, or nil if file not found.
  def load_file(filepath)
    return unless File.exist?(filepath)

    permitted = [
      ChessGame, ChessBoard, ChessPiece, Player, Symbol
    ] + ObjectSpace.each_object(Class).select { |c| c < ChessPiece }

    YAML.load_file(filepath, permitted_classes: permitted, aliases: true)
  end
end
