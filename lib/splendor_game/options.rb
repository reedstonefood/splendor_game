module SplendorGame

  class Options
    NOBLES_AVAILABLE = { 2 => 3, 3 => 4, 4 => 5}
    STARTING_GOLD_TOKENS = 5
    STARTING_NON_GOLD_TOKENS = { 2 => 4, 3 => 5, 4 => 7}
    DISPLAY_CARDS_PER_ROW = 4
    WINNING_SCORE = 15
    MIN_TO_TAKE_TWO = 4
    attr_reader :deck, :bank, :players, :nobles, :options, :display
    def initialize(user_options = nil)
      if user_options.is_a?(Hash)
        @user_options = user_options 
      else
        @user_options = Hash.new()
      end
    end
    
    def clean_user_options
      [:starting_non_gold_tokens, :nobles_available].each do |key|
        if @user_options[key].respond_to?(:keys)
          @user_options.delete(key) if !([2,3,4] - @user_options[key].keys).empty?
        end
      end
    end
    
    def default_options
      output = Hash.new()
      output[:display_cards_per_row] = DISPLAY_CARDS_PER_ROW
      output[:winning_score] = WINNING_SCORE
      output[:min_to_take_two] = MIN_TO_TAKE_TWO
      output[:starting_gold_tokens] = STARTING_GOLD_TOKENS
      output[:starting_non_gold_tokens] = STARTING_NON_GOLD_TOKENS
      output[:nobles_available] = NOBLES_AVAILABLE
      output
    end
    
    #Take the user values if they are valid, else use defaults
    def give_options
      clean_user_options
      @user_options.merge(default_options)
    end
    
  end
 
end