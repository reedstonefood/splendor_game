require "spec_helper"

describe SplendorGame::Turn do
  
  
  before :all do
    @g = SplendorGame::Game.new()
    #@p1 = SplendorGame::Player.new("Andrea", 1)
    #@p2 = SplendorGame::Player.new("Bob", 2)
    #@p3 = SplendorGame::Player.new("Charlie", 3)
    @g.add_player("Andrea")
    @g.add_player("Bob")
    @g.add_player("Charlie")
    @g.start_game
    @t = @g.next_turn
  end
  it "turn-game is a game" do
    expect(@t.game).to be_a_kind_of(SplendorGame::Game)
  end
  it "turn-player is a players" do
    expect(@t.player).to be_a_kind_of(SplendorGame::Player)
  end
  # this is returning an empty Hash when it should detail the cost
  context "affordable cards" do
    before :each do
      
      @t.player.tableau.reserve_card(SplendorGame::Card.new(1, :blue, {:white => 1, :green=> 1}))
      @t.player.tableau.reserve_card(SplendorGame::Card.new(1, :black, {:green=> 3}))
      @t.player.tableau.reserve_card(SplendorGame::Card.new(1, :black, {:white=> 1}))
    end
    it "affordable cards gives an array" do
      expect(@t.player.tableau.add_token(:white)).to eq(true)
      expect(@t.player.tableau.add_token(:gold)).to eq(true)
      expect(@t.player.tableau.tokens).to eq({:white =>1, :gold =>1})
      expect(@t.affordable_cards).to be_a_kind_of(Array)
      expect(@t.affordable_cards).to all(be_a_kind_of(Hash))
      expect(@t.affordable_cards.count).to eq(2)
    end
  end
end
