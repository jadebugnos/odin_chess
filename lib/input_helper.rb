module InputHelper
  def convert_input(input)
    input.map { |pos| algebraic_to_index(pos) }
  end

  def algebraic_to_index(pos)
    col = pos[0].ord - 'a'.ord
    row = 8 - pos[1].to_i
    [row, col]
  end
end
