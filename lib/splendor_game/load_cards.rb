module SplendorGame
  class Game
    #perhaps this can read from an external file eventually
    def load_cards
      @deck = Array.new()
      @deck << Card.new(1, :white, {:blue => 3})
      @deck << Card.new(1, :white, {:red => 2, :black => 1})
      @deck << Card.new(1, :white, {:red => 1, :black => 1, :green => 1, :blue => 1})
      @deck << Card.new(1, :white, {:black => 2, :blue => 2})
      @deck << Card.new(1, :white, {:green => 4}, 1)
    end
  end
end
