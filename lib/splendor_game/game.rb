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
    @@starting_gold_tokens = 5
    @@starting_non_gold_tokens = { 2=> 4, 3=>5, 4=>7}
    @@nobles_available = { 2=> 3, 3=>4, 4=>5}
    DISPLAY_CARDS_PER_ROW = 4
    WINNING_SCORE = 15
    attr_reader :deck, :bank, :players, :nobles, :options, :display
    def initialize(user_options = nil)
      @options = load_options(user_options)
      load_cards # puts all the cards into shuffled decks... a hash of arrays of cards. @deck[level]
      @bank = Tableau.new(0) # 0 means no limit on token capacity
      @players = Array.new()
      @turns = Array.new()
    end
    
    #Take the user values if they are valid, else use defaults
    def load_options(user_options)
      user_options = Hash.new() if user_options.nil?
      options = user_options
      options[:starting_gold_tokens] = @@starting_gold_tokens if user_options[:starting_gold_tokens].nil?
      options[:starting_gold_tokens] = @@starting_gold_tokens if !user_options[:starting_gold_tokens].is_natural_number?
      if user_options[:nobles_available].nil? || !user_options[:nobles_available].is_a?(Hash)
        options[:nobles_available] = @@nobles_available
      elsif user_options[:nobles_available].any? {|k,v| !k.is_natural_number? || !v.is_natural_number?}
        options[:nobles_available] = @@nobles_available
      elsif !([2,3,4] - options[:nobles_available].keys).empty?
        options[:nobles_available] = @@nobles_available
      end
      if user_options[:starting_non_gold_tokens].nil? || !user_options[:starting_non_gold_tokens].is_a?(Hash)
        options[:starting_non_gold_tokens] = @@starting_non_gold_tokens
      elsif user_options[:starting_non_gold_tokens].any? {|k,v| !k.is_natural_number? || !v.is_natural_number?}
        options[:starting_non_gold_tokens] = @@starting_non_gold_tokens
      elsif !([2,3,4] - options[:starting_non_gold_tokens].keys).empty?
        options[:starting_non_gold_tokens] = @@starting_non_gold_tokens
      end
      options
    end
    
    def add_player(player_name)
      return false if @players.count >= MAX_PLAYER_COUNT
      @players << Player.new(player_name, @players.count+1)
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
      return false if @players.map { |p| p.points }.max < WINNING_SCORE
      return true if @players[1] == @starting_player
      false
    end
    
    def start_game
      @bank.seed_bank_gold(@options[:starting_gold_tokens])
      @bank.seed_bank_non_gold(@@starting_non_gold_tokens[@players.count])
      #@bank.seed_bank_non_gold(@options[:starting_non_gold_tokens[@players.count]])
      #@nobles = noble_sample(@options[:nobles_available[@players.count]])
      @nobles = noble_sample(@@nobles_available[@players.count])
      @display = Hash.new()
      @deck.each { |level, subdeck| @display[level] = subdeck.pop(DISPLAY_CARDS_PER_ROW) }
    end
    
    def next_turn
      return false if game_over? || !defined? @display
      t = SplendorGame::Turn.new(self, next_player)
      @turns << t
      t
    end
    
    
  end
 
end