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

      How to Play (Two-Step Input):
        • Coordinates use letters a–h (files) and numbers 1–8 (ranks).
        • Step 1 — Select the piece:
            Type the square of the piece you want to move, then press Enter.
            Example: a2
        • Step 2 — Select the destination:
            Type the target square, then press Enter.
            Example: a4
          (Together, that move is: a2 → a4, entered as two separate inputs.)

        • You can type these commands at either step:
            - "save"  — save your current game
            - "exit"  — quit the game

      Quick piece reminders:
        • Pawns move forward (capture diagonally).
        • Knights move in an L-shape and can jump over pieces.
        • Bishops move diagonally; rooks move straight; the queen does both.
        • The king moves one square in any direction — protect him!

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
