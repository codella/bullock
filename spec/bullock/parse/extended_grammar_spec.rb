describe Bullock::Parse::ExtendedGrammar do
  let(:entry_point) { Bullock::Parse::Symbol.new('entry_point') }
  let(:start) { Bullock::Parse::Symbol.new('start') }
  let(:stop) { Bullock::Parse::Symbol.new('stop') }

  let(:action) { ->{} }

  it "instantiates an extended grammar" do
    production_1 = Bullock::Parse::Production.new(:entry_point, 'start', &action)
    production_2 = Bullock::Parse::Production.new(:start, 'stop', &action)

    i0_track_1 = Bullock::Parse::Track.new(production_1, 0)
    i0_track_2 = Bullock::Parse::Track.new(production_2, 0)
    i0 = Bullock::Parse::ItemSet.new([i0_track_1, i0_track_2])

    i1_track = Bullock::Parse::Track.new(production_2, 1)
    i1 = Bullock::Parse::ItemSet.new([i1_track])

    i2_track = Bullock::Parse::Track.new(production_1, 1)
    i2 = Bullock::Parse::ItemSet.new([i2_track])

    grammar = double(:grammar, productions: [production_1, production_2], start: :entry_point)

    dfa = double(:dfa, item_sets: [i0, i1, i2], translation_table: {
      [0, entry_point] => :END,
      [0, start] => 3,
      [0, stop] => 5
    })

    expanded_symbol_1 = Bullock::Parse::ExtendedSymbol.new(0, start, 3)
    symbol_1 = Bullock::Parse::ExtendedSymbol.new(0, stop, 5)
    x_production_1 = Bullock::Parse::ExtendedProduction.new(
      expanded_symbol_1,
      [symbol_1],
      action
    )

    expanded_symbol_2 = Bullock::Parse::ExtendedSymbol.new(0, entry_point, :END)
    symbol_2 = Bullock::Parse::ExtendedSymbol.new(0, start, 3)
    x_production_2 = Bullock::Parse::ExtendedProduction.new(
      expanded_symbol_2,
      [symbol_2],
      action
    )

    extended_grammar = Bullock::Parse::ExtendedGrammar.new(grammar, dfa)
    expect(extended_grammar.productions).to contain_exactly(x_production_1, x_production_2)
  end
end
