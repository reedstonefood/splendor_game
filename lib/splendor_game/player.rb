module SplendorGame
  
  class Player

    attr_reader :name, :turn_order, :tableau
  
    def initialize(name, turn_order)
      @name = name
      @turn_order = turn_order
      @tableau = Tableau.new()
    end

  end
 
end