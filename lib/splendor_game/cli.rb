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
    
    def help
      @@cli.say "************************ HELP! ************************"
      @@cli.say "<%= color('(b)uy', BOLD) %> = Buy a card"
      @@cli.say "<%= color('(r)eserve', BOLD) %> = Reserve a card"
      @@cli.say "<%= color('(t)okens', BOLD) %> = pick up tokens from the bank"
      @@cli.say "<%= color('(h)elp', BOLD) %> = This help page"
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
      if args[:turn].purchase_card(args[:card])
        true
      else
        @@cli.say "Oops, you can't afford that"
      end
    end
    
    def reserve_card(args)
      if args[:turn].reserve_card(args[:card])
        true
      else
        @@cli.say "Sorry, you can't reserve that (maybe you have reserved too many cards)"
      end
    end
    
    def do_turn(turn)
      turn_complete = false
      while turn_complete == false
        #full_display
        @@cli.say player_details(turn.player)
        input = @@cli.ask "What do you want to do, <%= color('#{turn.player.name}', BOLD) %>? "
        command = parse_command(input.downcase)
        if !command
          @@cli.say "Sorry, I did not understand that. Press h for help"
        elsif command==:buy || command==:reserve
          card = choose_card(command)
          if !(card==:cancel)
            if command==:buy
              turn_complete=true if purchase_card(:card => card, :turn => turn)
            end
            if command==:reserve
              turn_complete=true if reserve_card(:card => card, :turn => turn)
            end
            #TODO, what if we are reserving a random card?
          end
        elsif command==:tokens
          @@cli.say bank_details + " "
          turn_complete=true if take_tokens(turn)
        elsif command==:exit
          turn_complete=true
        end
      end
      @@cli.say "*** END OF TURN***"
      command==:exit ? false : true
    end
    
    def parse_command(input)
      case
      when input[0]=='b'
        return :buy
      when input[0]=='r'
        return :reserve
      when input[0]=='h'
        help
      when input[0]=='t'
        return :tokens
      when input[0]=='x'
        return :exit
      else
        return false
      end
      true
    end
    
    def card_display(card)
      text = "#{card.points}pts (#{card.colour}) => "
      card.cost.each do |k,v|
        text << "#{v} x #{k}, "
      end
      text[0..-3]
    end
    
    def player_details(player)
      str = "#{player.name.ljust(19)}: #{player.points.to_s.ljust(2)}pts. "
      reserved_card_count = player.tableau.reserved_cards.count
      str << "(#{reserved_card_count}R) " if reserved_card_count > 0
      str << "Cards: "
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
    
    def choose_card(mode)
      displayed_cards_list = @g.all_displayed_cards.collect { |c| [card_display(c),c] }.to_h
      if mode==:reserve
        (1..3).each { |i| displayed_cards_list["Reserve mystery level #{i} card"]= i }
      end
      @@cli.choose do |menu|
        menu.prompt = "Which card do you want to #{mode}? "
        menu.choices(*displayed_cards_list.keys) do |chosen|
          @@cli.say "Nice, you chose #{chosen}."
          displayed_cards_list[chosen]
        end
        menu.choice(:cancel) { false }
      end
    end
    
    def validate_token_choice(t)
      return false if t.count < 2 || t.count > 3
      t.each { |c| return false if !VALID_COLOUR_SYMBOLS.include?(c.upcase) || c==:gold}
      return false if t.count==2 && t[0] != t[1]
      true
    end
    
    def take_tokens(turn)
      input = @@cli.ask "Which tokens would you like (CSV format)? "
      requested_tokens = input.split(",")
      return false if !validate_token_choice(requested_tokens)
      if requested_tokens.count==2
        turn.take_two_tokens_same_colour(requested_tokens[0])
      elsif requested_tokens.count==3
        turn.take_different_tokens(requested_tokens)
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
    
  end

end
