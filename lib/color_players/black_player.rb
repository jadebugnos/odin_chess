class BlackPlayer < Player
  def initialize(name, color) # rubocop:disable Lint/MissingSuper
    @name = name
    @color = color
  end
end
