require 'bullock/parse/item_set'
require 'bullock/parse/definition'
require 'bullock/parse/grammar'

describe Bullock::Parse::ItemSet do
  describe ".from_productions" do
    it "creates an item set with correct pointed symbols" do
      definition = Bullock::Parse::Definition.new
      definition.production(:production_1, 'X production_2 Y')

      definition.symbol(:production_2) do
        produces('production_2 Z')
        produces('Z')
      end
      grammar = Bullock::Parse::Grammar.new(definition, start: :production_1)
      item_set = Bullock::Parse::ItemSet.from_productions(grammar.productions)

      symbols = item_set.pointed_symbols.map { |symbol| symbol[:symbol] }
      expect(symbols).to contain_exactly(:X, :Z, :production_1, :production_2)
    end
  end

  describe "#apply" do
  end

  describe "#==" do
  end
end
