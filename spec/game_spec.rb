require "spec_helper"

describe SplendorGame::Game do

  let(:g) { SplendorGame::Game.new }
  
  context "after game starts" do
    before :each do
      g.add_player("Player A")
      g.add_player("Player B")
      g.add_player("Player C")
      g.add_player("Player D")
      g.start_game
    end
    it "has 5 gold in the bank" do
      expect(g.bank.tokens[:gold]).to eq(5)
    end
    it "has 7 red in the bank" do
      expect(g.bank.tokens[:red]).to eq(7)
    end
    it "has 5 nobles" do
      expect(g.nobles).to be_a_kind_of(Array)
      expect(g.nobles.count).to be(5)
      expect(g.nobles).to all(be_a_kind_of(SplendorGame::Noble))
    end
    
  end
end
