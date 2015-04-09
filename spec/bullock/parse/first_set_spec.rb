require 'bullock/parse/first_set'
require 'bullock/parse/extended_production'
require 'bullock/parse/extended_symbol'
require 'bullock/parse/symbol'

describe Bullock::Parse::FirstSet do
  let(:symbol_T) { Bullock::Parse::Symbol.new(:T, false, true) }
  let(:symbol_n) { Bullock::Parse::Symbol.new(:n, false, true) }

  let(:x_T) { Bullock::Parse::ExtendedSymbol.new(0, symbol_T, 1) }
  let(:x_n) { Bullock::Parse::ExtendedSymbol.new(0, symbol_n, 1) }

  it "produces the first_set for a single production grammar" do
    production = ::Bullock::Parse::ExtendedProduction.new(x_n, [x_T], Proc.new {})
    grammar = double(:extended_grammar)
    allow(grammar).to receive(:start) { x_n }
    allow(grammar).to receive(:terminals) { [x_T] }
    allow(grammar).to receive(:productions) { [production] }
    allow(grammar).to receive(:productions_by).with(x_n) { [production] }

    expect(::Bullock::Parse::FirstSet.new.process(grammar)).to eq ({
      x_T => [x_T],
      x_n => [x_T]
    })
  end
end
