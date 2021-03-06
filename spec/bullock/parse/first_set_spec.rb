describe Bullock::Parse::FirstSet do
  let(:x_Y) do
    symbol = Bullock::Parse::Symbol.new('Y')
    Bullock::Parse::ExtendedSymbol.new(0, symbol, 1)
  end

  let(:x_Z) do
    symbol = Bullock::Parse::Symbol.new('Z')
    Bullock::Parse::ExtendedSymbol.new(0, symbol, 1)
  end

  let(:x_a) do
    symbol = Bullock::Parse::Symbol.new('a')
    Bullock::Parse::ExtendedSymbol.new(0, symbol, 1)
  end

  let(:x_b) do
    symbol = Bullock::Parse::Symbol.new('b')
    Bullock::Parse::ExtendedSymbol.new(0, symbol, 1)
  end

  it "puts :EMPTY in the first set if there is an explicit empty production" do
    production = Bullock::Parse::ExtendedProduction.new(x_a, [], Proc.new {})

    grammar = double(:extended_grammar)
    allow(grammar).to receive(:start) { x_a }
    allow(grammar).to receive(:terminals) { [] }
    allow(grammar).to receive(:productions) { [production] }
    allow(grammar).to receive(:productions_by).with(x_a) { [production] }

    expect(Bullock::Parse::FirstSet.new.process(grammar)).to eq ({
      x_a => Set.new([:EMPTY])
    })
  end

  it "puts terminal in first set if there is a production to that terminal" do
    production = Bullock::Parse::ExtendedProduction.new(x_a, [x_Z], Proc.new {})
    grammar = double(:extended_grammar)
    allow(grammar).to receive(:start) { x_a }
    allow(grammar).to receive(:terminals) { [x_Z] }
    allow(grammar).to receive(:productions) { [production] }
    allow(grammar).to receive(:productions_by).with(x_a) { [production] }

    expect(Bullock::Parse::FirstSet.new.process(grammar)).to eq ({
      x_Z => Set.new([:Z]),
      x_a => Set.new([:Z])
    })
  end

  it "puts :EMPTY in first set if the expansion can be empty" do
    production_a = Bullock::Parse::ExtendedProduction.new(x_a, [x_b], Proc.new {})
    production_b = Bullock::Parse::ExtendedProduction.new(x_b, [], Proc.new {})

    grammar = double(:extended_grammar)
    allow(grammar).to receive(:start) { x_a }
    allow(grammar).to receive(:terminals) { [] }
    allow(grammar).to receive(:productions) { [production_a, production_b] }
    allow(grammar).to receive(:productions_by).with(x_a) { [production_a] }
    allow(grammar).to receive(:productions_by).with(x_b) { [production_b] }

    expect(Bullock::Parse::FirstSet.new.process(grammar)).to eq ({
      x_a => Set.new([:EMPTY]),
      x_b => Set.new([:EMPTY])
    })
  end

  it "puts terminal in first set if also when there is a production to an empty non-terminal before" do
    production_a = Bullock::Parse::ExtendedProduction.new(x_a, [x_b, x_Z], Proc.new {})
    production_b = Bullock::Parse::ExtendedProduction.new(x_b, [], Proc.new {})

    grammar = double(:extended_grammar)
    allow(grammar).to receive(:start) { x_a }
    allow(grammar).to receive(:terminals) { [x_Z] }
    allow(grammar).to receive(:productions) { [production_a, production_b] }
    allow(grammar).to receive(:productions_by).with(x_a) { [production_a] }
    allow(grammar).to receive(:productions_by).with(x_b) { [production_b] }

    expect(Bullock::Parse::FirstSet.new.process(grammar)).to eq ({
      x_Z => Set.new([:Z]),
      x_a => Set.new([:Z]),
      x_b => Set.new([:EMPTY])
    })
  end

  it "keeps processing the expansion if non-terminal contains :EMPTY" do
    production_a = Bullock::Parse::ExtendedProduction.new(x_a, [x_b, x_Z], Proc.new {})
    production_b_1 = Bullock::Parse::ExtendedProduction.new(x_b, [x_Y], Proc.new {})
    production_b_2 = Bullock::Parse::ExtendedProduction.new(x_b, [], Proc.new {})

    grammar = double(:extended_grammar)
    allow(grammar).to receive(:start) { x_a }
    allow(grammar).to receive(:terminals) { [x_Z, x_Y] }
    allow(grammar).to receive(:productions) { [production_a, production_b_1, production_b_2] }
    allow(grammar).to receive(:productions_by).with(x_a) { [production_a] }
    allow(grammar).to receive(:productions_by).with(x_b) { [production_b_1, production_b_2] }

    expect(Bullock::Parse::FirstSet.new.process(grammar)).to eq ({
      x_Y => Set.new([:Y]),
      x_Z => Set.new([:Z]),
      x_a => Set.new([:Y, :Z]),
      x_b => Set.new([:Y, :EMPTY])
    })
  end
end
