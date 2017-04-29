require "spec_helper"

describe SplendorGame::Turn do
  
  
  before :each do
    @g = SplendorGame::Game.new()
    @g.add_player("Andrea")
    @g.add_player("Bob")
    @g.add_player("Charlie")
    @g.start_game
    @t = @g.next_turn
  end
  context "affordable cards" do
    before :each do
      
      @t.player.tableau.reserve_card(SplendorGame::Card.new(1, :blue, {:white => 1, :green=> 1}))
      @t.player.tableau.reserve_card(SplendorGame::Card.new(1, :black, {:green=> 3}))
      @t.player.tableau.reserve_card(SplendorGame::Card.new(1, :black, {:white=> 1}))
    end
    it "affordable cards works as expected" do
      expect(@t.player.tableau.add_token(:white)).to eq(true)
      expect(@t.player.tableau.add_token(:gold)).to eq(true)
      expect(@t.player.tableau.tokens).to eq({:white =>1, :gold =>1})
      expect(@t.affordable_cards).to be_a_kind_of(Array)
      expect(@t.affordable_cards).to all(be_a_kind_of(Hash))
      expect(@t.affordable_cards.count).to eq(2)
    end
  end
  context "reserve card" do
    before :each do
      @t.reserve_card(@g.display[1][0])
    end
    it "gives the player a gold token" do
      expect(@t.player.tableau.tokens).to eq({:gold =>1})
    end
    it "the player has one reserved card" do
      expect(@t.player.tableau.reserved_cards.count).to eq(1)
    end
    it "leaves a gap in the cards on display" do
      expect(@g.display[1].count).to eq(SplendorGame::Game::DISPLAY_CARDS_PER_ROW-1)
    end
  end
  context "purchase card" do
    it "won't let you buy a card you can't afford" do
      expect(@t.purchase_card(@g.display[1][0])).to eq(false)
    end
    context "if you can afford the card" do
      before :each do
        5.times { @t.player.tableau.add_token(:gold) } #enough to afford any level 1 card
      end
      it "will let you by a card you can afford" do
        expect(@t.purchase_card(@g.display[1][0])).not_to eq(false)
      end
      it "will mean the player has 1 card and there's a gap in the display" do
        expect(@t.purchase_card(@g.display[1][0])).not_to eq(false)
        expect(@t.player.tableau.cards.size).to eq(1)
        expect(@g.display[1].count).to eq(SplendorGame::Game::DISPLAY_CARDS_PER_ROW-1)
        
      end
    end
  end
  context "pick two tokens of the same colour" do
    it "won't let you if there are too few in the bank" do
      while @g.bank.tokens[:red] >= @g.options[:min_to_take_two] do
        @g.bank.remove_token(:red)
      end
      expect(@t.take_two_tokens_same_colour(:red)).to eq(false)
    end
    it "will let you if there are sufficient, and leave the correct number in bank/player's tableaus" do
      initial_reds = @g.bank.tokens[:red]
      expect(@t.take_two_tokens_same_colour(:red)).not_to eq(false)
      expect(@t.player.tableau.tokens[:red]).to eq(2)
      expect(@g.bank.tokens[:red]).to eq(initial_reds-2)
    end
  end
end
