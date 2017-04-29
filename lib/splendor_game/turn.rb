module SplendorGame
  
  class Turn
    attr_reader :player
  
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
      cost_to_player = @player.tableau.tokens_required(card)
      return false if !cost_to_player
      return false if !@game.display.flatten(2).include? (card)
      @player.tableau.purchase_card(card)
      cost_to_player.each do |colour, val|
        val.times { @player.tableau.remove_token(colour) }
        val.times { @game.bank.add_token(colour) }
      end
      display_row = @game.display[card.level]
      display_row.delete_at(display_row.index(card) || display_row.length)
    end
    
    def reserve_card(card) # put cards in to player's reserved set. Remove card from display
      return false if !@player.tableau.can_reserve_card?
      return false if !@game.display.flatten(2).include? (card)
      @player.tableau.reserve_card(card)
      display_row = @game.display[card.level]
      display_row.delete_at(display_row.index(card) || display_row.length)
      if @game.bank.tokens[:gold] > 0 && @player.tableau.token_space_remaining>0
        @game.bank.remove_token(:gold)
        @player.tableau.add_token(:gold)
      end
      true
    end
    
    def take_two_tokens_same_colour(colour)
      return false if @game.bank.tokens[colour] < @game.options[:min_to_take_two]
      2.times { @player.tableau.add_token(colour) }
      2.times { @game.bank.remove_token(colour) }
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
