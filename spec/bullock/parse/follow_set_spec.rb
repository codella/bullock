require 'set'

describe Bullock::Parse::FollowSet do
  let(:x_Z) do
    symbol = Bullock::Parse::Symbol.new(:Z, false, true)
    Bullock::Parse::ExtendedSymbol.new(0, symbol, 1)
  end

  let(:x_a) do
    symbol = Bullock::Parse::Symbol.new(:a, false, false)
    Bullock::Parse::ExtendedSymbol.new(0, symbol, 1)
  end

  let(:x_b) do
    symbol = Bullock::Parse::Symbol.new(:b, false, false)
    Bullock::Parse::ExtendedSymbol.new(0, symbol, 1)
  end

  it "puts :END in the follow set of the start symbol" do
    grammar = double(:extended_grammar)
    allow(grammar).to receive(:start) { x_a }
    allow(grammar).to receive(:productions) { [] }

    first_set = {}
    expect(Bullock::Parse::FollowSet.new.process(first_set, grammar)).to eq ({
      x_a => Set.new([:END])
    })
  end

  it "puts first set of the rest in last non-teminal follow set present in expansion" do
    production = Bullock::Parse::ExtendedProduction.new(x_a, [x_b, x_Z], Proc.new {})

    grammar = double(:extended_grammar)
    allow(grammar).to receive(:start) { x_a }
    allow(grammar).to receive(:productions) { [production] }

    first_set = { x_Z => [:Z] }
    expect(Bullock::Parse::FollowSet.new.process(first_set, grammar)).to eq ({
      x_a => Set.new([:END]),
      x_b => Set.new([:Z])
    })
  end

  it "puts follow_set of extended in last non-teminal follow set present in expansion" do
    production_a = Bullock::Parse::ExtendedProduction.new(x_a, [x_b], Proc.new {})
    production_b = Bullock::Parse::ExtendedProduction.new(x_b, [x_Z], Proc.new {})

    grammar = double(:extended_grammar)
    allow(grammar).to receive(:start) { x_a }
    allow(grammar).to receive(:productions) { [production_a, production_b] }

    first_set = { x_Z => [:Z] }
    expect(Bullock::Parse::FollowSet.new.process(first_set, grammar)).to eq ({
      x_a => Set.new([:END]),
      x_b => Set.new([:END])
    })
  end
end
