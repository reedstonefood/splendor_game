require "spec_helper"

describe SplendorGame::Turn do
  
  
  before :each do
    @g = SplendorGame::Game.new()
    @g.add_player("Andrea")
    @g.add_player("Bob")
    @g.add_player("Charlie")
    @g.start_game
    @t = @g.next_turn
  end
  context "affordable cards" do
    before :each do
      
      @t.player.tableau.reserve_card(SplendorGame::Card.new(1, :blue, {:white => 1, :green=> 1}))
      @t.player.tableau.reserve_card(SplendorGame::Card.new(1, :black, {:green=> 3}))
      @t.player.tableau.reserve_card(SplendorGame::Card.new(1, :black, {:white=> 1}))
    end
    it "affordable cards works as expected" do
      expect(@t.player.tableau.add_token(:white)).to eq(true)
      expect(@t.player.tableau.add_token(:gold)).to eq(true)
      expect(@t.player.tableau.tokens).to eq({:white =>1, :gold =>1})
      expect(@t.affordable_cards).to be_a_kind_of(Array)
      expect(@t.affordable_cards).to all(be_a_kind_of(Hash))
      expect(@t.affordable_cards.count).to eq(2)
    end
  end
  context "reserve card" do
    before :each do
      @t.reserve_card(@g.display[1][0])
    end
    it "gives the player a gold token" do
      expect(@t.player.tableau.tokens).to eq({:gold =>1})
    end
    it "the player has one reserved card" do
      expect(@t.player.tableau.reserved_cards.count).to eq(1)
    end
    it "leaves a gap in the cards on display" do
      expect(@g.display[1].count).to eq(@g.options[:display_cards_per_row]-1)
    end
  end
  context "purchase card" do
    it "won't let you buy a card you can't afford" do
      expect(@t.purchase_card(@g.display[1][0])).to eq(false)
    end
    context "if you can afford the card" do
      before :each do
        5.times { @t.player.tableau.add_token(:gold) } #enough to afford any level 1 card
      end
      it "will let you by a card you can afford" do
        expect(@t.purchase_card(@g.display[1][0])).not_to eq(false)
      end
      it "will mean the player has 1 card and there's a gap in the display" do
        expect(@t.purchase_card(@g.display[1][0])).not_to eq(false)
        expect(@t.player.tableau.cards.size).to eq(1)
        expect(@g.display[1].count).to eq(@g.options[:display_cards_per_row]-1)
        
      end
    end
  end
  context "pick two tokens of the same colour" do
    it "won't let you if there are too few in the bank" do
      while @g.bank.tokens[:red] >= @g.options[:min_to_take_two] do
        @g.bank.remove_token(:red)
      end
      expect(@t.take_two_tokens_same_colour(:red)).to eq(false)
    end
    it "will let you if there are sufficient, and leave the correct number in bank/player's tableaus" do
      initial_reds = @g.bank.tokens[:red]
      expect(@t.take_two_tokens_same_colour(:red)).not_to eq(false)
      expect(@t.player.tableau.tokens[:red]).to eq(2)
      expect(@g.bank.tokens[:red]).to eq(initial_reds-2)
    end
  end
  context "pick three different tokens" do
    it "won't let you if the colours aren't in the bank" do
      while @g.bank.tokens[:green] > 0 do
        @g.bank.remove_token(:green)
      end
      expect(@t.take_different_tokens([:green, :red, :blue])).to eq(false)
    end
    it "won't let you if two of the colours are the same" do
      expect(@t.take_different_tokens([:green, :blue, :green])).to eq(false)
    end
    it "won't let you if you ask for more than 3 colours" do
      expect(@t.take_different_tokens([:green, :red, :blue, :white])).to eq(false)
    end
    it "if request is valid, it works, gives player 3 tokens and takes 3 from the bank" do
      inital_tokens = @g.bank.token_count
      expect(@t.take_different_tokens([:green, :red, :blue])).not_to eq(false)
      expect(@t.player.tableau.token_count).to eq(3)
      expect(@g.bank.token_count).to eq(inital_tokens-3)
    end
  end
  context "action return tokens" do
    it "won't let you return a colour you don't have" do
      expect(@t.action_return_token(:black)).to eq(false)
    end
    it "will let you return a colour you do have, and give correct totals" do
      inital_tokens = @g.bank.token_count
      @t.player.tableau.add_token(:black)
      expect(@t.action_return_token(:black)).not_to eq(false)
      expect(@t.player.tableau.token_count).to eq(0)
      expect(@g.bank.token_count).to eq(inital_tokens+1)
    end
  end
  context "claim noble" do
    it "won't let you claim one at the start as you have 0 cards" do
      expect(@t.claim_noble(@g.nobles[0])).to eq(false)
    end
    context "if you can afford it" do
      before :each do
        cost = @g.nobles[0].cost
        cost.each do |c, v|
          v.times { @t.player.tableau.add_token(:red) }
          v.times { @t.player.tableau.purchase_card(SplendorGame::Card.new(1, c.to_sym, {:red=>1})) }
        end
      end
      it "should have loaded some cards into your tableau" do
        expect(@t.player.tableau.cards.count).not_to eq(0)
      end
      it "it lets you buy one" do
        expect(@t.claim_noble(@g.nobles[0])).not_to eq(false)
      end
      it "player's score and size of nobles have increased accordingly" do
        nobles_available = @g.nobles.count
        expect(@t.claim_noble(@g.nobles[0])).not_to eq(false)
        expect(@t.player.nobles.count).to eq(1)
        expect(@t.player.points).to eq(@t.player.nobles[0].points)
        expect(@g.nobles.count).to eq(nobles_available-1)
      end
    end
  end
end