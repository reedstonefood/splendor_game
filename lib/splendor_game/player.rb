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
    
  end
 
end