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
          q.validate = lambda { |a| a.length >= 1 && a.length <= 30 }
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
      @@cli.say "<%= color('e(x)it', BOLD) %> = Exit the program (doesn't work yet)"
    end
    
    def full_display
      @g.display.each do |row, deck|
        @@cli.say "ROW #{row}"
        deck.each do |card| 
          @@cli.say card_display(card)
        end
      end
    end
    
    def do_turn(turn)
      turn_complete = false
      while turn_complete == false
        full_display
        input = @@cli.ask "What do you want to do, <%= color('#{turn.player.name}', BOLD) %>? "
        command = parse_command(input.downcase)
        if !command
          @@cli.say "Sorry, I did not understand that. Press h for help"
        elsif command==:buy || command==:reserve
          if !card = choose_card(command)
            turn.purchase_card(card) if command==:buy
            turn.reserve_card(card) if command==:reserve
            turn_complete = true
          end
        elsif command==:tokens
          @@cli.say "You chose tokens (not yet coded)"
        end
      end
      @@cli.say "*** END OF TURN***"
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
    
    def choose_card(mode)
      displayed_cards_list = @g.display.values.flatten.collect { |c| card_display(c) }
      @@cli.choose do |menu|
        menu.prompt = "Which card do you want to #{mode}? "
        menu.choices(*displayed_cards_list) do |chosen|
          @@cli.say "Nice, you chose #{chosen}."
          @g.display.values.flatten.find { |c| card_display(c)==chosen }
        end
        menu.choice(:cancel) { false }
      end
    end
    
    
    
    
    def end_game_detail
      @@cli.say "The game consisted of #{g.turns.count} turns"
      @@cli.ask "It's the end of the game. Press enter to end the program."
      @@cli.say "Goodbye!"
    end
    
    
    def main
      @g.start_game
      catch :exit do
        loop do
          turn = @g.next_turn
          throw :exit if !do_turn(turn) # or @exit_flag==true ??
        end #end of the game - only reachable by throwing an :exit
      end
      end_game_detail
    end
    
  end

end
