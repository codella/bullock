describe Bullock::Parse::ExtendedGrammar do
  let(:entry_point) { Bullock::Parse::Symbol.new(:__entry_point_start) }
  let(:start) { Bullock::Parse::Symbol.new(:start) }
  let(:stop) { Bullock::Parse::Symbol.new(:stop) }

  it "instantiates an extended grammar" do
    action = Proc.new {}
    definition = Bullock::Parse::Definition.new
    definition.instance_exec do
      production(:start, 'stop', &action)
    end
    grammar = Bullock::Parse::Grammar.new(definition, start: :start)
    dfa = Bullock::Parse::ItemSetsDfa.process(grammar)

    i0_track_1 = Bullock::Parse::Track.new(entry_point, [start], 0, action)
    i0_track_2 = Bullock::Parse::Track.new(start, [stop], 0, action)
    i0 = Bullock::Parse::ItemSet.new([i0_track_1, i0_track_2])

    i1_track = Bullock::Parse::Track.new(start, [stop], 1, action)
    i1 = Bullock::Parse::ItemSet.new([i1_track])

    i2_track = Bullock::Parse::Track.new(entry_point, [start], 1, action)
    i2 = Bullock::Parse::ItemSet.new([i2_track])

    dfa = Bullock::Parse::ItemSetsDfa.process(grammar)
    is = dfa.item_sets

    expanded_symbol_1 = Bullock::Parse::ExtendedSymbol.new(is.find_index(i0), start, is.find_index(i2))
    symbol_1 = Bullock::Parse::ExtendedSymbol.new(is.find_index(i0), stop, is.find_index(i1))
    production_1 = Bullock::Parse::ExtendedProduction.new(
      expanded_symbol_1,
      [symbol_1],
      action
    )

    expanded_symbol_2 = Bullock::Parse::ExtendedSymbol.new(is.find_index(i0), entry_point, :END)
    symbol_2 = Bullock::Parse::ExtendedSymbol.new(is.find_index(i0), start, is.find_index(i2))
    production_2 = Bullock::Parse::ExtendedProduction.new(
      expanded_symbol_2,
      [symbol_2],
      action
    )

    extended_grammar = Bullock::Parse::ExtendedGrammar.new(grammar, dfa)
    expect(extended_grammar.productions).to contain_exactly(production_1, production_2)
  end
end
