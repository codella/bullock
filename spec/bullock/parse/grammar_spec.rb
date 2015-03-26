require 'bullock/parse/grammar'

describe Bullock::Parse::Grammar do
  it "creates the __entry_point symbol" do
    definition = Bullock::Parse::Definition.new
    definition.production(:a_symbol, 'expansion') {}

    instance = Bullock::Parse::Grammar.new(definition, start: :a_symbol)

    entry_point = Bullock::Parse::Production.new(:__entry_point_a_symbol, 'a_symbol') {}
    expect(instance.productions).to contain_exactly(entry_point, definition.productions.first)
  end
end
