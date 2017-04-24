module SplendorGame
  class Game
    #perhaps this can read from an external file eventually
    def load_cards
      all_cards = Array.new()
      all_cards << Card.new(1, :white, {:blue => 3})
      all_cards << Card.new(1, :white, {:red => 2, :black => 1})
      all_cards << Card.new(1, :white, {:red => 1, :black => 1, :green => 1, :blue => 1})
      all_cards << Card.new(1, :white, {:black => 2, :blue => 2})
      all_cards << Card.new(1, :white, {:green => 4}, 1)
    
    
      # Now all cards are in all_cards, distribute them into all_cards
      @deck = Hash.new()
      all_cards.each do |card|
        @deck[card.level] = Array.new() if !@deck.include?(card.level)
        @deck[card.level] << card
      end
      # shuffle them
      @deck.each { |smaller_deck| smaller_deck.shuffle! }
    end
    
    def noble_sample(cards_to_load)
      all_nobles = Array.new()
      all_nobles << Noble.new({:white => 3, :blue => 3, :black => 3}, 3)
      all_nobles << Noble.new({:blue => 3, :green => 3, :red => 3}, 3)
      all_nobles << Noble.new({:white => 3, :red => 3, :black => 3}, 3)
      all_nobles << Noble.new({:white => 3, :blue => 3, :green => 3}, 3)
      all_nobles << Noble.new({:green => 3, :red => 3, :black => 3}, 3)
      all_nobles << Noble.new({:green => 4, :red => 4}, 3)
      all_nobles << Noble.new({:blue => 4, :green => 4}, 3)
      all_nobles << Noble.new({:red => 4, :black => 4}, 3)
      all_nobles << Noble.new({:white => 4, :black => 4}, 3)
      all_nobles << Noble.new({:white => 4, :blue => 4}, 3)
      all_nobles.shuffle!.first(cards_to_load)
    end
  end
end
