module SplendorGame
  
 
  class Tableau
    @@max_reserved_cards = 3
    attr_reader :cards, :tokens, :token_limit, :reserved_cards
    
    def initialize(token_limit = 10)
      @cards = Array.new()
      @tokens = Hash.new(0)
      @unlimited = token_limit <= 0 ? true : false
      @token_limit = token_limit
      @reserved_cards = Array.new()
    end
    
    def seed_bank_non_gold(token_count)
      VALID_COLOUR_SYMBOLS.each do |colour|
        @tokens[colour] = token_count if colour != :gold
      end
    end
    
    def seed_bank_gold(token_count)
      @tokens[:gold] = token_count
    end
    
    def add_token(token_colour)
      return false if !VALID_COLOUR_SYMBOLS.include? (token_colour)
      return false if !@unlimited && token_count >= @token_limit
      if @tokens.include? (token_colour)
        @tokens[token_colour] += 1
      else
        @tokens[token_colour] = 1
      end
      true
    end
    
    def remove_token(token_colour)
      return false if !@tokens.key? (token_colour)
      return false if @tokens[token_colour] <= 0
      @tokens[token_colour] -= 1
      true
    end
    
    def token_count
      @tokens.inject(0) { |sum,(k,v)| sum + v }
    end
    
    def purchase_card(card)
      return false if tokens_required(card) == false
      @cards << card
    end
    
    def play_reserved_card(card)
      return false unless can_afford?(card)
      return false unless @reserved_cards.include? (card)
      @cards << card
      @reserved_cards.delete(card)
      
    end
    
    def reserve_card(card)
      return false if @reserved_cards.size >= @@max_reserved_cards
      @reserved_cards << card
    end
    
    # Returns a Hash of the tokens required to buy the card
    # If the tableau does not have sufficient cards/tokens, it returns false
    def tokens_required(card)
      answer = Hash.new(0)
      card.cost.each do |colour, col_cost|
        theoretical_tokens = col_cost - colours_on_cards(colour)
        if theoretical_tokens <= @tokens[colour]
          answer[colour] = theoretical_tokens if theoretical_tokens > 0
        else
          answer[colour] = @tokens[colour]
          answer[:gold] += theoretical_tokens - @tokens[colour]
        end
      end
      return false if answer[:gold] > @tokens[:gold]
      answer
    end
    
    
    def is_empty?
      @cards.size==0 && @tokens.size==0 ? true : false
    end
    
    def colours_on_cards(colour)
      @cards.inject(0) { |sum,card| sum + 1 if card.colour == colour }
    end
    
  end
 
end