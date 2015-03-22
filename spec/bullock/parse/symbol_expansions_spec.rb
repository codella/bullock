require 'bullock/parse/production'
require 'bullock/parse/symbol_expansions'

describe Bullock::Parse::SymbolExpansions do
  describe "#expands" do
    it "no Productions are given if #produces is never invoked" do
      instance = Bullock::Parse::SymbolExpansions.new(:symbol)

      expect(instance.productions).to be_empty
    end

    it "creates a Production with symbol and a single expansion" do
      instance = Bullock::Parse::SymbolExpansions.new(:symbol)

      instance.produces('a b c')

      production = Bullock::Parse::Production.new(:symbol, 'a b c')
      expect(instance.productions).to eq [production]
    end

    it "creates a single Production with instance_eval" do
      instance = Bullock::Parse::SymbolExpansions.new(:symbol)

      instance.instance_eval do
        produces('a b c')
      end

      production = Bullock::Parse::Production.new(:symbol, 'a b c')
      expect(instance.productions).to eq [production]
    end

    it "creates Productions with symbol and and two expansions" do
      instance = Bullock::Parse::SymbolExpansions.new(:symbol)

      instance.produces('a b c')
      instance.produces('x y z')

      abc_production = Bullock::Parse::Production.new(:symbol, 'a b c')
      xyz_production = Bullock::Parse::Production.new(:symbol, 'x y z')
      expect(instance.productions).to eq [abc_production, xyz_production]
    end
  end
end
