class Bullock::Parse::LALR1
  def initialize(start: :start)
    grammar = yield production
    item_sets = ::Bullock::Parse::ItemSets.new(grammar)
    translation_table = ::Bullock::Parse::TranslationTable.new(item_sets)
    extended_grammar = ::Bullock::Parse::ExtendedGrammar.new(translation_table)
    first_sets = ::Bullock::Parse::FirstSets(extended_grammar)
    follow_sets = ::Bullock::Parse::FollowSets(extended_grammar)
    @action_goto_table = ::Bullock::Parse::ActionGotoTable.new(first_sets, follow_sets)
  end

  def perform(tokens)
    @action_goto_table.perform(tokens)
  end
end
