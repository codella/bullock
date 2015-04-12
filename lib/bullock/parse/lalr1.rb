class Bullock::Parse::LALR1
  def initialize(grammar)
    dfa = ::Bullock::Parse::ItemSetsDfa.new.process(grammar)
    extended_grammar = ::Bullock::Parse::ExtendedGrammar.new(dfa)
    first_sets = ::Bullock::Parse::FirstSet.new.process(extended_grammar)
    follow_sets = ::Bullock::Parse::FollowSet.new(first_set, extended_grammar)
    @action_goto_table = ::Bullock::Parse::ActionGotoTable.new(follow_sets, dfa)
  end

  def parse(tokens)
    @action_goto_table.perform(tokens)
  end
end
