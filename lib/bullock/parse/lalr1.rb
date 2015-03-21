class Bullock::Parse::LALR1
  def initialize(start: :start)
    grammar = yield production
    item_sets_dfa = ::Bullock::Parse::ItemSetsDfa.new.from(grammar)
    extended_grammar = ::Bullock::Parse::ExtendedGrammar.new(item_sets_dfa)
    first_sets = ::Bullock::Parse::FirstSets.new(extended_grammar)
    follow_sets = ::Bullock::Parse::FollowSets.new(extended_grammar)
    @action_goto_table = ::Bullock::Parse::ActionGotoTable.new(first_sets, follow_sets)
  end

  def perform(tokens)
    @action_goto_table.perform(tokens)
  end
end
