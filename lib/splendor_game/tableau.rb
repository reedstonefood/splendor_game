module SplendorGame
  
 
  class Tableau
    
    attr_reader :cards, :tokens, :token_limit
    
    def initialize(token_limit = 10)
      @cards = Array.new()
      @tokens = Hash.new()
      @unlimited = token_limit <= 0 ? true : false
      @token_limit = token_limit
    end
    
    def add_token(token_colour)
    
    end
    
    def is_empty?
      @cards.size==0 && @tokens.size==0 ? true : false
    end
    
  end
 
end