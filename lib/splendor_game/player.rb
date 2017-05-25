module SplendorGame
  
  class Player

    attr_reader :name, :turn_order, :tableau, :nobles
  
    def initialize(name, turn_order)
      @name = name
      @turn_order = turn_order
      @tableau = Tableau.new()
      @nobles = Array.new()
    end

    def points
      card_points = @tableau.cards.inject(0) { |sum,c| sum + c.points }
      card_points + @nobles.inject(0) { |sum,c| sum + c.points }
    end
    
    def can_afford_noble?(noble)
      noble.cost.each do |k, v|
        return false if @tableau.colours_on_cards(k) < v 
      end
      true
    end
    
    def claim_noble(noble)
      return false if !can_afford_noble?(noble)
      @nobles << noble
      true
    end
  end
 
end