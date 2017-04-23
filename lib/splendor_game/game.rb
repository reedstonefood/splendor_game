module SplendorGame
  class Game
    @@starting_gold_tokens = 5
    @@starting_non_gold_tokens = { 2=> 4, 3=>5, 4=>7}
    attr_reader :deck, :bank, :players
    def initialize
      load_cards
      @bank = Tableau.new(0) # 0 means no limit on token capacity
      @players = Array.new()
    end
    
    def add_player(player_name)
      return false if @players.count >= MAX_PLAYER_COUNT
      @players << Player.new(player_name, @players.count+1)
    end
    
    def start_game
      @bank.seed_bank_gold(@@starting_gold_tokens)
      @bank.seed_bank_non_gold(@@starting_non_gold_tokens[@players.count])
    end
    
  end

 
end