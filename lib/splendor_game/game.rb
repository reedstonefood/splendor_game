class Object
  def is_natural_number?
    return false if !self.is_a?(Numeric)
    return false if self < 0
    return false if self != self.abs
    true
  end
end

module SplendorGame


  class Game
    #DISPLAY_CARDS_PER_ROW = 4
    #WINNING_SCORE = 15
    #MIN_TO_TAKE_TWO = 4
    attr_reader :deck, :bank, :players, :nobles, :options, :display, :turns
    def initialize(user_options = nil)
      @options = Options.new(user_options).give_options
      load_cards # puts all the cards into shuffled decks... a hash of arrays of cards. @deck[level]
      @bank = Tableau.new(0) # 0 means no limit on token capacity
      @players = Array.new()
      @turns = Array.new()
    end
    
    def add_player(player_name)
      return false if @players.count >= MAX_PLAYER_COUNT
      @players << Player.new(player_name, @players.count+1)
      true
    end
    
    def next_player
      if !@turns.empty?
        @players.rotate!
        return @players.first
      end
      @players.shuffle!
      @starting_player = @players.first
    end
    
    def game_over?
      return false if @players.map { |p| p.points }.max < @options[:winning_score]
      return true if @players[1] == @starting_player
      false
    end
    
    def start_game
      @bank.seed_bank({:options=> @options, :player_count => @players.count})
      @nobles = noble_sample(@options[:nobles_available][@players.count])
      @display = Hash.new()
      @deck.each { |level, subdeck| @display[level] = subdeck.pop(@options[:display_cards_per_row]) }
    end
    
    def next_turn
      return false if game_over? || !defined? @display
      t = SplendorGame::Turn.new(self, next_player)
      @turns << t
      t
    end
    
    def all_displayed_cards
      @display.values.flatten
    end
    
  end
 
end