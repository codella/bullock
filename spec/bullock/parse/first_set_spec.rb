require 'bullock/parse/first_set'
require 'bullock/parse/extended_grammar'
require 'bullock/parse/item_sets_dfa'
require 'bullock/parse/definition'
require 'bullock/parse/grammar'

describe Bullock::Parse::FirstSet do
  let(:extended_grammar) do
    definition = Bullock::Parse::Definition.new
    definition.instance_exec do
      production(:a, 'b T1 c T2 d') {}
      production(:b, 'c T3') {}
      production(:c, 'd T4') {}
      production(:d, 'T5 T6') {}
    end
    grammar = Bullock::Parse::Grammar.new(definition, start: :a)
    dfa = Bullock::Parse::ItemSetsDfa.process(grammar)
    Bullock::Parse::ExtendedGrammar.new(grammar, dfa)
  end

  it "produces the first_set" do
    #expect(::Bullock::Parse::FirstSet.new.process(extended_grammar)).to contain_exactly()
  end
end
