class Bullock::Parse::LALR1
  def initialize(grammar)
    dfa = ::Bullock::Parse::ItemSetsDfa.new.process(grammar)
    extended_grammar = ::Bullock::Parse::ExtendedGrammar.new(dfa)
    first_sets = ::Bullock::Parse::FirstSet.new.process(extended_grammar)
    follow_sets = ::Bullock::Parse::FollowSet.new(first_set, extended_grammar)
    @goto_table = ::Bullock::Parse::GotoTable.new(dfa.transitions)
  end

  def parse(tokens)
  end
end
