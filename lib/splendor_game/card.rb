module SplendorGame
  VALID_COLOUR_LIST = ["RED", "BLUE", "BLACK", "GREEN", "RED"]

  class Card
    attr_reader :level, :points, :colour, :cost
  
    def initialize(level, colour, cost, points = 0)
      @level = level
      @points = points
      @colour = colour
      @cost = cost # this is a Hash
    end
    
    def can_afford?(tableau)
      return false
    end
    
    # format any inputted colours to the downcase symbol version
    # return false if an invalid input is passed in
    def validate_colour(input)
      if VALID_COLOUR_LIST.exists(input.upcase)
        input.downcase.to_sym
      else 
        false
      end
    end
    
	end

end
