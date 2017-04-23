module SplendorGame
  
  class Card
    attr_reader :level, :points, :colour, :cost
  
    def initialize(level, colour, cost, points = 0)
      @level = level
      @points = points
      @colour = colour
      @cost, @cost_error = Hash.new(), Hash.new()
      # if the colour is valid, load it, if not, put it in an error hash
      cost.each do |key, value|
        new_key_name = validate_colour(key)
        if new_key_name==false
          @cost_error[key] = value
        else
          @cost[new_key_name] = value
        end
      end
    end
    
    private
    # format any inputted colours to the downcase symbol version
    # return false if an invalid input is passed in
    def validate_colour(input)
      if VALID_COLOUR_LIST.include? (input.to_s.upcase)
        input.downcase.to_sym
      else 
        false
      end
    end
    
	end

end
