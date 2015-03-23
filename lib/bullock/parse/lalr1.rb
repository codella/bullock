class Bullock::Parse::LALR1
  attr_reader :action_goto_table

  def initialize(grammar)
    item_sets_dfa = ::Bullock::Parse::ItemSetsDfa.new.process(grammar)
    # extended_grammar = ::Bullock::Parse::ExtendedGrammar.new(item_sets_dfa)
    # first_sets = ::Bullock::Parse::FirstSets.new(extended_grammar)
    # follow_sets = ::Bullock::Parse::FollowSets.new(extended_grammar)
    # @action_goto_table = ::Bullock::Parse::ActionGotoTable.new(first_sets, follow_sets)
  end

  def parse(tokens)
    action_goto_table.perform(tokens)
  end
end
