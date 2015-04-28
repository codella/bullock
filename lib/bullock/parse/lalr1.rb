class Bullock::Parse::LALR1
  def initialize(grammar)
    dfa = ::Bullock::Parse::ItemSetsDfa.new.process(grammar)
    extended_grammar = ::Bullock::Parse::ExtendedGrammar.new(grammar, dfa)
    first_sets = ::Bullock::Parse::FirstSet.new.process(extended_grammar)
    follow_sets = ::Bullock::Parse::FollowSet.new.process(first_sets, extended_grammar)
    goto_table = ::Bullock::Parse::GotoTable.new(dfa.transitions)
byebug
    @action_table = Hash.new { |hash, key| hash[key] = {} }
    ::Bullock::Parse::AcceptTable.new.process(@action_table, dfa.states)
    ::Bullock::Parse::ShiftTable.new.process(@action_table, dfa.transitions)
    ::Bullock::Parse::ReduceTable.new.process(
      @action_table,
      extended_grammar.productions,
      follow_sets,
      goto_table
    )
  end

  def parse(tokens)
    stack = [ [0, nil] ]
    outcomes = tokens.map do |token|
      last_state = stack.last[0]
      action = @action_table[last_state][token.token]
      raise "Syntax error" if action.nil?
      action.call(stack, token)
    end
    raise "Syntax error" unless outcomes.last == :accept
  end
end
