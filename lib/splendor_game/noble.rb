module SplendorGame
  
  #Players become eligible for Nobles when they have cards that meet the cost (NOT tokens)
  class Noble < ColouredObject
    attr_reader :cost, :points
  
    def initialize(cost, points = 0)
      @points = points
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
  end

end
