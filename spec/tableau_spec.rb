require "spec_helper"

describe SplendorGame::Tableau do

  let(:t) { SplendorGame::Tableau.new }
  it "cards is an empty array" do
    expect(t.cards).to be_a_kind_of(Array)
    expect(t.cards).to be_empty
  end
  it "tokens is an empty hash" do
    expect(t.tokens).to be_a_kind_of(Hash)
    expect(t.tokens).to be_empty
  end
  it "correctly models the maximum number of cards" do
    expect(t.token_limit).to eq(10)
  end
end
