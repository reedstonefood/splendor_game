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
  
  context "nobles" do
    let (:n) {SplendorGame::Noble.new({:blue => 4, :red => 4},3)}
    let (:red_card) {SplendorGame::Card.new(0, :red, {})}
    let (:blue_card) {SplendorGame::Card.new(0, :blue, {})}
    
    it "says you can't afford it initially" do
      expect(p.can_afford_noble?(n)).to eq(false)
    end
    it "says you can afford it if you can afford it" do
      4.times {p.tableau.purchase_card(red_card)}
      4.times {p.tableau.purchase_card(blue_card)}
      expect(p.can_afford_noble?(n)).to eq(true)
    end
    
    it "gives you the noble if you ask for it" do
      4.times {p.tableau.purchase_card(red_card)}
      4.times {p.tableau.purchase_card(blue_card)}
      expect(p.claim_noble(n)).to eq(true)
      expect(p.nobles.count).to eq(1)
      expect(p.nobles.first).to eq(n)
      expect(p.points).to eq(3)
    end
  end
end
