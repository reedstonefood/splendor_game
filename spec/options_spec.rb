require "spec_helper"

describe SplendorGame::Options do
  
  context "default options" do
    let(:o) { SplendorGame::Options.new }
    let(:r) { o.give_options }
    it "returns the basic options" do
      expect(r[:display_cards_per_row]).to eq(SplendorGame::Options::DISPLAY_CARDS_PER_ROW)
      expect(r[:winning_score]).to eq(SplendorGame::Options::WINNING_SCORE)
      expect(r[:starting_gold_tokens]).to eq(SplendorGame::Options::STARTING_GOLD_TOKENS)
      expect(r[:min_to_take_two]).to eq(SplendorGame::Options::MIN_TO_TAKE_TWO)
    end
    it "returns the hash options" do
      expect(r[:starting_non_gold_tokens]).to be_a_kind_of(Hash)
      expect(r[:nobles_available]).to be_a_kind_of(Hash)
      expect(r[:starting_non_gold_tokens]).to eq(SplendorGame::Options::STARTING_NON_GOLD_TOKENS)
      expect(r[:nobles_available]).to eq(SplendorGame::Options::NOBLES_AVAILABLE)
    end
  end
end
