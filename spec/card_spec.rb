require "spec_helper"

describe SplendorGame::Card do

  let(:c) { SplendorGame::Card.new(1, :white, {:blue => 3, :green => 1, :pie => 8}) }
  it "gives the correct color, level and points" do
    expect(c.colour).to eq(:white)
    expect(c.level).to eq(1)
    expect(c.points).to eq(0)
  end
  it "stores the correct cost and ignores rubbish input" do
    expect(c.cost).to be_a_kind_of(Hash)
    expect(c.cost.size).to eq(2)
  end
end
