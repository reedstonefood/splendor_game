require "spec_helper"

describe SplendorGame::Game do
  it "has a version number" do
    expect(SplendorGame::VERSION).not_to be nil
  end

  let(:g) { SplendorGame::Game.new }
  it "deck is a Hash of Array of Cards" do
    expect(g.deck).to be_a_kind_of(Hash)
    expect(g.deck).to all(be_an(Array))
    expect(g.deck[1]).to all(be_a_kind_of(SplendorGame::Card)) #can't figure out how to test that every element of g.deck is an Array of hashes
                                                               #However I can test a specific one
  end
end
