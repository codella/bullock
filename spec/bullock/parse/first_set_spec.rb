require 'bullock/parse/first_set'
require 'bullock/parse/extended_production'
require 'bullock/parse/extended_symbol'
require 'bullock/parse/symbol'

describe Bullock::Parse::FirstSet do
  let(:_Y) { Bullock::Parse::Symbol.new(:Y, false, true) }
  let(:x_Y) { Bullock::Parse::ExtendedSymbol.new(0, _Y, 1) }

  let(:_Z) { Bullock::Parse::Symbol.new(:Z, false, true) }
  let(:x_Z) { Bullock::Parse::ExtendedSymbol.new(0, _Z, 1) }

  let(:_a) { Bullock::Parse::Symbol.new(:a, false, false) }
  let(:x_a) { Bullock::Parse::ExtendedSymbol.new(0, _a, 1) }

  let(:_b) { Bullock::Parse::Symbol.new(:b, false, false) }
  let(:x_b) { Bullock::Parse::ExtendedSymbol.new(0, _b, 1) }

  it "puts :EMPTY in the first set if there is an explicit empty production" do
    production = Bullock::Parse::ExtendedProduction.new(x_a, [], Proc.new {})

    grammar = double(:extended_grammar)
    allow(grammar).to receive(:start) { x_a }
    allow(grammar).to receive(:terminals) { [] }
    allow(grammar).to receive(:productions) { [production] }
    allow(grammar).to receive(:productions_by).with(x_a) { [production] }

    expect(Bullock::Parse::FirstSet.new.process(grammar)).to eq ({
      x_a => [:EMPTY]
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
      x_Z => [x_Z],
      x_a => [x_Z]
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
      x_a => [:EMPTY],
      x_b => [:EMPTY]
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
      x_Z => [x_Z],
      x_a => [x_Z],
      x_b => [:EMPTY]
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
      x_Y => [x_Y],
      x_Z => [x_Z],
      x_a => [x_Y, x_Z],
      x_b => [x_Y, :EMPTY]
    })
  end
end
