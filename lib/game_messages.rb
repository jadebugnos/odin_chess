require 'colorize'

module GameMessages
  MESSAGES = {
    input_format: '[Invalid] Incorrect input format.',
    occupied_source_cell: '[Invalid] No piece at the source cell.',
    players_turn: '[Invalid] Not your turn.',
    piece_legal_move: '[Invalid] Illegal move for this piece.',
    empty_destination: '[Invalid] Destination cell is empty.',
    king_safety: '[Invalid] Move would place or leave your king in check.'
  }.freeze

  def self.game_intro
    <<~INTRO
      ♔♕♖♗♘♙  Welcome to Ruby Chess  ♟♞♝♜♛♚

      Two armies face off on the 8x8 battlefield.
      Your goal: Checkmate your opponent’s king.

      Each piece moves in unique patterns — strategy, patience,
      and foresight will lead you to victory.

      May your moves be bold and your tactics sharp!

      Let the game begin...

    INTRO
  end

  def self.print_warning(results)
    failed_validation = results.key(false)

    puts MESSAGES[failed_validation]
  end

  def self.declare_check
    puts '❗CHECK❗'.colorize(:red)
  end

  def self.declare_checkmate
    puts '❗❗ CHECKMATE ❗❗'.colorize(:red)
  end
end
