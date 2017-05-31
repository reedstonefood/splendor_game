require 'highline'

module SplendorGame
  
  class CLI
    @@cli = HighLine.new
    attr_reader :level, :points, :colour, :cost
  
    def initialize
      @g = SplendorGame::Game.new Hash[*ARGV]
      choose_players
      main
    end
    
    def choose_players
      count = 1 
      @@cli.say "Name all the players. Input 'done' when you are done."
      loop do
        pname = @@cli.ask("Enter name of player #{count} > ") do |q| 
          q.validate = lambda { |a| a.length >= 1 && a.length <= 19 }
        end
        if pname.downcase == 'done'
          break if count > MIN_PLAYER_COUNT
          @@cli.say "You need to input at least 2 players!"
        elsif @g.add_player(pname)== true
          count += 1
          @@cli.say "*** #{pname} successfully added"
        else
          @@cli.say "*** Sorry, there was a problem adding player #{pname}"
        end
        break if count > MAX_PLAYER_COUNT
      end
      @@cli.say "Succesfully added #{count-1} players. Game is ready to start."
    end
    
    def puts_help
      @@cli.say "************************ HELP! ************************"
      @@cli.say "<%= color('(b)uy', BOLD) %> = Buy a card"
      @@cli.say "<%= color('(r)eserve', BOLD) %> = Reserve a card"
      @@cli.say "<%= color('(t)okens', BOLD) %> = pick up tokens from the bank"
      @@cli.say "<%= color('(h)elp', BOLD) %> = This help page"
      #TODO - display nobles!
      @@cli.say "<%= color('e(x)it', BOLD) %> = Exit the program"
    end
    
    def full_display
      @g.display.each do |row, deck|
        @@cli.say "ROW #{row}"
        deck.each do |card| 
          @@cli.say card_display(card)
        end
      end
    end
    
    #practicing using args rather than fixed list of parameters
    def purchase_card(args)
      #if args[:turn].player.tableau.reserved_cards.include?(args[:card])
      #  args[:turn].reserve_card
      if args[:turn].purchase_card(args[:card])
        true
      else
        @@cli.say "Oops, you can't afford that"
      end
    end
    
    def reserve_card(args)
      if args[:card].is_a?(SplendorGame::Card) && args[:turn].reserve_displayed_card(args[:card])
        true
      elsif args[:card].is_a?(Integer) && args[:turn].reserve_random_card(args[:card])
        true
      else
        @@cli.say "Sorry, you can't reserve that (maybe you have reserved too many cards)"
      end
    end
    
    def do_turn(turn)
      while turn.action_done == false
        output_all_player_details(turn.player)
        input = @@cli.ask "What do you want to do, <%= color('#{turn.player.name}', BOLD) %>? "
        command_result = process_command(input.downcase, turn)
        if !command_result
          @@cli.say "Sorry, I did not understand that. Press h for help"
        elsif command_result==:exit
          break
        end
      end
      consider_nobles(turn)
      turn.end_turn
      @@cli.say "*** END OF TURN***"
      command_result==:exit ? false : true
    end
    
    def process_command(input, turn)
      case
      when input[0]=='b'
        card = choose_card(:buy, turn.player)
        purchase_card(:card => card, :turn => turn) if card
      when input[0]=='r'
        card = choose_card(:reserve, turn.player)
        reserve_card(:card => card, :turn => turn) if card
      when input[0]=='h'
        puts_help
      when input[0]=='t'
        @@cli.say bank_details + " "
        take_tokens(turn)
      when input[0]=='x'
        return :exit
      else
        return false
      end
      true
    end
    
    
    def card_display(card)
      text = "#{card.points}pts "
      text << "(#{card.colour}) => " if card.instance_variable_defined?(:@colour)
      card.cost.each do |k,v|
        text << "#{v} x #{k}, "
      end
      text[0..-3]
    end
    
    def output_all_player_details(highlighted_player=nil)
      @g.players.each do |p|
        if p==highlighted_player
          str = "<%= color('"
          str << player_details(p)
          str << "', BOLD) %>"
        else
          str = player_details(p)
        end
        @@cli.say str
      end
    end
    
    def player_details(player)
      str = "#{player.name.ljust(19)}: #{player.points.to_s.ljust(2)}pts. "
      reserved_card_count = player.tableau.reserved_cards.count
      str << "(#{reserved_card_count}R) " if reserved_card_count > 0
      str << "Cards (#{player.tableau.cards.count}): "
      player.tableau.all_colours_on_cards.sort.to_h.each do |colour, count|
        str << "#{colour}=#{count} " if count > 0
      end
      str << "Tokens: "
      player.tableau.tokens.sort.to_h.each do |colour,count|
        str << "#{colour}=#{count} " if count > 0
      end
      str[0..-2]
    end
    
    def bank_details
      str = "Bank tokens = "
      @g.bank.tokens.sort.to_h.each do |colour, count|
        str << "#{colour}=#{count} " if count > 0
      end
      str
    end
    
    def choose_card(mode, player = nil)
      displayed_cards_list = @g.all_displayed_cards.collect { |c| [card_display(c),c] }.to_h
      if mode==:reserve
        (1..3).each { |i| displayed_cards_list["Reserve mystery level #{i} card"]= i }
      end
      if mode==:buy
        player.tableau.reserved_cards.each_with_index do |card, index| 
          displayed_cards_list["R#{index+1} - #{card_display(card)}"]= card
        end
      end
      @@cli.choose do |menu|
        menu.prompt = "Which card do you want to #{mode}? "
        menu.choices(*displayed_cards_list.keys) do |chosen|
          @@cli.say "Nice, you chose #{chosen}."
          displayed_cards_list[chosen]
        end
        menu.choice(:cancel) { return false }
      end
    end
    
    def validate_token_choice(t)
      return false if [2,3].include?(t.count)
      t.each { |c| return false if !VALID_COLOUR_SYMBOLS.include?(c.upcase) || c==:gold}
      return false if t.count==2 && t[0] != t[1]
      true
    end
    
    def take_tokens(turn)
      input = @@cli.ask "Which tokens would you like (CSV format)? "
      requested_tokens = input.split(",")
      #return false if !validate_token_choice(requested_tokens)
      if requested_tokens.count==2
        response = turn.take_two_tokens_same_colour(requested_tokens[0])
      elsif requested_tokens.count==3
        response = turn.take_different_tokens(requested_tokens)
      end
      @@cli.say "Oops, that's not a valid selection" if !response
    end
    
    def consider_nobles(turn)
      possibles = turn.claimable_nobles
      return false if possibles.empty?
      return assign_only_valid_noble(turn, possibles) if possibles.count==1
      @@cli.ask "You qualify for multiple nobles! Pick one..."
      displayed_nobles_list = possibles.collect { |c| [card_display(c),c] }.to_h
      @@cli.choose do |menu|
        menu.prompt = "You qualify for multiple nobles! Pick one... "
        menu.choices(*displayed_nobles_list.keys) do |chosen_noble|
          turn.claim_noble(chosen_noble)
          @@cli.say "Nice, you chose #{chosen_noble}."
        end
      end
      
    end
    
    def end_game_detail
      @@cli.say "The game consisted of #{@g.turns.count} turns"
      @@cli.ask "It's the end of the game. Press enter to end the program."
      @@cli.say "Goodbye!"
    end
    
    
    def main
      @g.start_game
      catch :exit do
        loop do
          turn = @g.next_turn
          throw :exit if turn===false # or @exit_flag==true ??
          throw :exit if !do_turn(turn) 
        end #end of the game - only reachable by throwing an :exit
      end
      end_game_detail
    end
    
    private
    def assign_only_valid_noble(turn,noble_array)
      the_noble = noble_array.first
      if !turn.claim_noble(the_noble)
        @@cli.say "Looks like you qualify for a noble, but it didn't work"
        return false
      else
        @@cli.say "You have been given a noble! #{the_noble.points} points"
        return true
      end
    end
    
  end

end
