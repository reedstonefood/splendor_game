module SplendorGame
  
  class ColouredObject
    private
    # format any inputted colours to the downcase symbol version
    # return false if an invalid input is passed in
    def validate_colour(input)
      if VALID_COLOUR_LIST.include?(input.to_s.upcase)
        input.downcase.to_sym
      else 
        false
      end
    end
    
  end

end
