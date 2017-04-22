require "spec_helper"

describe SplendorGame::Player do

  let(:p) { SplendorGame::Player.new("Bob", 1) }
  it "returns name correctly" do
    expect(p.name).to eq("Bob")
  end
  it "returns turn order correctly" do
    expect(p.turn_order).to eq(1)
  end
  it "correctly creates an empty Tableau" do
    expect(p.tableau).to be_a_kind_of(SplendorGame::Tableau)
    expect(p.tableau.is_empty?).to eq(true)
  end
end
