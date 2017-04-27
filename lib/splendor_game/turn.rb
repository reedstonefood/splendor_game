module SplendorGame
  
  class Turn
    attr_reader :player, :game
  
    def initialize(game, player)
      @game = game
      @player = player
    end
    
    #from the 12 cards on display plus up to 3 reserved ones, return the ones affordable, in an Array
    def affordable_cards
      answer = Array.new()
      (@game.display.values.flatten + @player.tableau.reserved_cards).each do |card|
        @cost = @player.tableau.tokens_required(card)
        answer << @cost if !@cost==false
      end
      answer
    end
    
    def purchase_card(card) # do the requisite card/token changes, if the card is in affordable_cards
  
    end
    
    def reserve_card(card) # put cards in to player's reserved set. Remove card from display
    end
    
    def take_two_tokens_same_colour(colour) # does what it says on the tin
    end
  
    def take_different_tokens(colours)
    
    end
  
    # in order to claim tokens you may need to return tokens, eg pick up a gold when 
    # you have 10, or you have 8 and want to take 3 different. This action only pretends to do it
    def prepare_return_token 
    end
    

    def action_return_token # actually returns tokens as shown in prepare_return_token
    end
  
    def claim_noble(noble) # Move noble from bank to player, assuming it's affordable
  
    end
  
    def restock_display # make sure there are 4 cards showing from each deck, assuming there are any left
      @game.deck.find_all {|level, subdeck|  @game.display[level].count < Game::DISPLAY_CARDS_PER_ROW }.each do |level2, subdeck2|
        @game.display[level2] << subdeck2.pop if subdeck2.count > 0
      end
    end
    
	end

end
