module SplendorGame
  
  class Turn
    attr_reader :player, :action_done
  
    def initialize(game, player)
      @game = game
      @player = player
      @action_done = false
      @noble_claimed = false
    end
    
    #from the 12 cards on display plus up to 3 reserved ones, return the ones affordable, in an Array
    def affordable_cards
      answer = Array.new()
      (@game.all_displayed_cards + @player.tableau.reserved_cards).each do |card|
        @cost = @player.tableau.tokens_required(card)
        answer << card if !@cost==false
      end
      answer
    end
    
    def purchase_card(card) # do the requisite card/token changes, if the card is in affordable_cards
      return false if @action_done
      return false if !affordable_cards.include?(card)
      cost_to_player = @player.tableau.tokens_required(card)
      if @player.tableau.reserved_cards.include?(card)
        @player.tableau.play_reserved_card(card)
      else
        @player.tableau.purchase_card(card)
      end
      cost_to_player.each do |colour, val|
        val.times { @player.tableau.remove_token(colour) }
        val.times { @game.bank.add_token(colour) }
      end
      display_row = @game.display[card.level]
      display_row.delete_at(display_row.index(card) || display_row.length)
      @action_done = true
    end
    
    def reserve_card(card) # put cards in to player's reserved set. Remove card from display
      return false if @action_done
      return false if !@player.tableau.can_reserve_card?
      return false if !@game.display.flatten(2).include?(card)
      @player.tableau.reserve_card(card)
      display_row = @game.display[card.level]
      display_row.delete_at(display_row.index(card) || display_row.length)
      if @game.bank.tokens[:gold] > 0 && @player.tableau.token_space_remaining > 0
        @game.bank.remove_token(:gold)
        @player.tableau.add_token(:gold)
      end
      @action_done = true
    end
    
    def validate_token_pickup?(colour)
      return false if @action_done
      return false if Array(colour).include?(:gold)
      true
    end
    
    def take_two_tokens_same_colour(colour)
      colour = colour.to_sym
      return false if !validate_token_pickup?(colour)
      return false if @game.bank.tokens[colour] < @game.options[:min_to_take_two]
      2.times { @player.tableau.add_token(colour) }
      2.times { @game.bank.remove_token(colour) }
      @action_done = true
    end
  
    def take_different_tokens(colours)
      colours.map!{|c| c.to_sym}
      return false if !validate_token_pickup?(colours)
      return false if colours.count != 3
      return false if colours.uniq.length != colours.length
      return false if colours.select { |c| @game.bank.tokens[c]==0}.length > 0
      colours.each do |c|
        @player.tableau.add_token(c)
        @game.bank.remove_token(c)
      end
      @action_done = true
    end
  
    # in order to claim tokens you may need to return tokens, eg pick up a gold when 
    # you have 10, or you have 8 and want to take 3 different. 
    
    def action_return_token(colour)
      return false if !@player.tableau.tokens.include?(colour) 
      return false if @player.tableau.tokens[colour] <= 0
      @player.tableau.remove_token(colour)
      @game.bank.add_token(colour)
    end
  
    def claim_noble(noble) # Move noble from bank to player, assuming it's affordable
      return false if @noble_claimed # you can only claim 1 per turn
      return false if !@game.nobles.include?(noble)
      return false if noble.class.name!='SplendorGame::Noble'
      noble.cost.each do |c,v|
        return false if @player.tableau.colours_on_cards(c) < v
      end
      @game.nobles.delete_at(@game.nobles.index(noble) || display_row.length)
      @player.nobles << noble
      @noble_claimed = true
    end
  
    def end_turn # make sure there are 4 cards showing from each deck, assuming there are any left
      #assumption : max 1 card is missing from each row
      nonfull_rows = @game.display.select { |_level, subdeck| subdeck.count < @game.options[:display_cards_per_row] }
      nonfull_rows.each do |row_num, display_row|
        relevant_deck = @game.deck[row_num]
        display_row << relevant_deck.pop if relevant_deck.count > 0
      end
    end
    
  end

end
