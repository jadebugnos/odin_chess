# this file defines the Pieces class which holds the chess pieces logic
class ChessPiece
  attr_accessor :positions

  def initialize # rubocop:disable Metrics/MethodLength
    # Hash of initial piece positions
    @positions = {
      white: {
        "\u2656" => [[7, 0], [7, 7]], # rook
        "\u2658" => [[7, 1], [7, 6]], # knight
        "\u2657" => [[7, 2], [7, 5]], # bishop
        "\u2655" => [[7, 3]],         # queen
        "\u2654" => [[7, 4]],         # king
        "\u2659" => (0..7).map { |col| [6, col] } # pawn
      },
      black: {
        "\u265C" => [[0, 0], [0, 7]], # rook
        "\u265E" => [[0, 1], [0, 6]], # knight
        "\u265D" => [[0, 2], [0, 5]], # bishop
        "\u265B" => [[0, 3]],         # queen
        "\u265A" => [[0, 4]],         # king
        "\u265F" => (0..7).map { |col| [1, col] } # pawn
      }
    }
  end
end
