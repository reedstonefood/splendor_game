module SplendorGame
  
 
  class Tableau
    @@max_reserved_cards = 3
    attr_reader :cards, :tokens, :reserved_cards
    
    def initialize(token_limit)
      @cards = Array.new()
      @tokens = Hash.new(0)
      @unlimited = token_limit <= 0 ? true : false
      @token_limit = token_limit
      @reserved_cards = Array.new()
    end
    
    def seed_bank(args)
      seed_bank_non_gold(args[:options][:starting_non_gold_tokens][args[:player_count]])
      seed_bank_gold(args[:options][:starting_gold_tokens])
    end
    
    ### add tokens, remove tokens, counting tokens
    
    def add_token(token_colour)
      return false if !VALID_COLOUR_SYMBOLS.include?(token_colour)
      return false if !@unlimited && token_count >= @token_limit
      if @tokens.include?(token_colour)
        @tokens[token_colour] += 1
      else
        @tokens[token_colour] = 1
      end
      true
    end
    
    def remove_token(token_colour)
      return false if !@tokens.key?(token_colour)
      return false if @tokens[token_colour] <= 0
      @tokens[token_colour] -= 1
      true
    end
    
    def token_count
      @tokens.inject(0) { |sum,(_k,v)| sum + v }
    end
    
    def token_space_remaining
      return nil if @unlimited == true #meaning, undefined
      @token_limit - token_count
    end
    
    def distinct_token_colour_count
      @tokens.count { |_k,v| v >0 }
    end
    
    #### reserving cards
    
    def can_reserve_card?
      return false if @reserved_cards.size >= @@max_reserved_cards
      true
    end

    def reserve_card(card)
      return false if !can_reserve_card?
      @reserved_cards << card
    end    
    
    def play_reserved_card(card)
      return false if tokens_required(card) == false
      return false unless @reserved_cards.include?(card)
      @cards << card
      @reserved_cards.delete(card)
    end
    
    ### related to purchasing cards
      
    def purchase_card(card)
      return false if tokens_required(card) == false
      @cards << card
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
    
    def all_colours_on_cards
      output = Hash.new()
      VALID_COLOUR_SYMBOLS.each { |c| output[c] = colours_on_cards(c) if colours_on_cards(c) > 0 }
      output
    end
    
    def colours_on_cards(colour)
      @cards.inject(0) { |sum,card| card.colour == colour ? sum+1 : sum }.to_i
    end
    
    ### Other
    
    def is_empty?
      @cards.size==0 && @tokens.size==0 ? true : false
    end
    
    ### setup
    private
    
    def seed_bank_non_gold(token_count)
      VALID_COLOUR_SYMBOLS.each do |colour|
        @tokens[colour] = token_count if colour != :gold
      end
    end
    
    def seed_bank_gold(token_count)
      @tokens[:gold] = token_count
    end
    
  end
 
end