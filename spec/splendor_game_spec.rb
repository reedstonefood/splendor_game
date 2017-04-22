require "spec_helper"

describe SplendorGame::Game do
  it "has a version number" do
    expect(SplendorGame::VERSION).not_to be nil
  end

  let(:g) { SplendorGame::Game.new }
  it "deck is an Array of Cards" do
    expect(g.deck).to be_a_kind_of(Array)
    #expect(g.deck).to all(be_an(SplendorGame::Card))
  end
end
