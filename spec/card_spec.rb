require "spec_helper"

describe SplendorGame::Card do

  let(:c) { SplendorGame::Card.new(1, :white, [:blue => 3]) }
  it "gives the correct color, level and points" do
    expect(c.colour).to eq(:white)
    expect(c.level).to eq(1)
    expect(c.points).to eq(0)
  end
end
