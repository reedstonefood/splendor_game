require "spec_helper"

describe SplendorGame::Tableau do

  let(:max_tokens) {10}
  let(:t) { SplendorGame::Tableau.new(max_tokens) }
  it "cards is an empty array" do
    expect(t.cards).to be_a_kind_of(Array)
    expect(t.cards).to be_empty
  end
  it "tokens is an empty hash" do
    expect(t.tokens).to be_a_kind_of(Hash)
    expect(t.tokens).to be_empty
  end
  it "correctly models the maximum number of cards" do
    expect(t.token_space_remaining).to eq(max_tokens)
  end
  
  context "add a blue token" do
    before { t.add_token(:blue) }
    it "correctly reports the adding of a blue token" do
      expect(t.tokens).to eq ({:blue => 1})
    end
    it "says it has 9 tokens remaining" do
      expect(t.token_space_remaining ).to eq (9)
    end
    it "says it is not empty" do
      expect(t.is_empty?).to eq (false)
    end
  end
  
  context "add 3 blue tokens, add green token, minus blue token" do
    before :each do
      t.add_token(:blue)
      t.add_token(:blue) 
      t.add_token(:blue)
      t.add_token(:green)
      t.remove_token(:blue)
    end
    it "correctly says it has 2 blue and 1 green" do
      expect(t.tokens).to eq ({:blue => 2, :green => 1})
    end
    it "says it has 3 tokens total" do
      expect(t.token_count).to eq (3)
    end
    it "says it is not empty" do
      expect(t.is_empty?).to eq (false)
    end
  end
  
  context "trying to buy a card" do
    let (:c) {SplendorGame::Card.new(1, :white, {:blue => 2, :green => 1})}
    before :each do
      t.add_token(:blue)
      t.add_token(:green)
    end
    it "will not let you buy it if you don't have the tokens" do
      expect(t.tokens_required(c)).to eq(false)
      expect(t.purchase_card(c)).to eq(false)
    end
    it "will let you buy it if you have a gold" do
      t.add_token(:gold)
      expect(t.tokens_required(c)).to eq({:blue => 1, :green => 1, :gold => 1})
      expect(t.purchase_card(c)).not_to eq(false)
      expect(t.cards.size).to eq(1)
    end
    it "will let you buy it if you have another blue" do
      t.add_token(:blue)
      expect(t.tokens_required(c)).to eq({:blue => 2, :green => 1})
      expect(t.purchase_card(c)).not_to eq(false)
      expect(t.cards.size).to eq(1)
    end
    it "tells you you have 1 white card" do
      t.add_token(:blue)
      expect(t.tokens_required(c)).to eq({:blue => 2, :green => 1})
      expect(t.purchase_card(c)).not_to eq(false)
      expect(t.colours_on_cards(:white)).to eq(1)
    end
    it "tells you you have 1 white card in if you ask for all your cards" do
      t.add_token(:blue)
      expect(t.tokens_required(c)).to eq({:blue => 2, :green => 1})
      expect(t.purchase_card(c)).not_to eq(false)
      expect(t.all_colours_on_cards).to eq({:white => 1})
    end
    
  end
  
  context "reserving cards" do
    before :each do
      t.reserve_card(SplendorGame::Card.new(1, :white, {:blue => 2, :green => 1}))
      t.reserve_card(SplendorGame::Card.new(0, :white, {:red => 1, :green => 1}))
    end
    it "will let you reserve a third card" do
      expect(t.can_reserve_card?).to eq(true)
      t.reserve_card(SplendorGame::Card.new(2, :white, {:red => 5}))
    end
    it "will not let you reserve a fourth card" do
      t.reserve_card(SplendorGame::Card.new(2, :white, {:red => 5}))
      expect(t.can_reserve_card?).to eq(false)
      expect(t.reserve_card(SplendorGame::Card.new(2, :white, {:red => 5}))).to eq(false)
    end
  end
  
  
end
