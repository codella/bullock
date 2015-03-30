require 'bullock/parse/grammar'

describe Bullock::Parse::Grammar do
  it "creates the __entry_point symbol" do
    definition = Bullock::Parse::Definition.new
    definition.instance_exec do
      production(:a_symbol, 'expansion') {}
    end

    instance = Bullock::Parse::Grammar.new(definition, start: :a_symbol)

    entry_point = Bullock::Parse::Production.new(:__entry_point_a_symbol, 'a_symbol') {}
    expect(instance.productions).to contain_exactly(entry_point, definition.productions.first)
  end

  describe "#terminals" do
    it "returns all the terminal symbols" do
      definition = Bullock::Parse::Definition.new
      definition.instance_exec do
        production(:rule1, 'TERM1 a TERM2') {}
        production(:rule2, 'TERM3') {}
      end

      instance = Bullock::Parse::Grammar.new(definition, start: :rule1)

      expect(instance.terminals.map(&:symbol)).to contain_exactly(:TERM1, :TERM2, :TERM3)
    end
  end

  describe "#non_terminals" do
    it "returns all the non terminal symbols" do
      definition = Bullock::Parse::Definition.new
      definition.instance_exec do
        production(:rule1, 'TERM1 a TERM2 b') {}
        production(:rule2, 'c TERM3 d') {}
      end

      instance = Bullock::Parse::Grammar.new(definition, start: :rule1)

      expect(instance.non_terminals.map(&:symbol)).to contain_exactly(
        :__entry_point_rule1,
        :a,
        :b,
        :c,
        :d,
        :rule1
      )
    end
  end
end
