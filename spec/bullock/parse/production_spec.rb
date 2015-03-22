require 'bullock/parse/production'

describe Bullock::Parse::Production do
  describe "#==" do
    it "returns false when symbol is different" do
      production = Bullock::Parse::Production.new(:symbol, 'expansion')
      other_production = Bullock::Parse::Production.new(:another_symbol, 'expansion')

      expect(production == other_production).to be_falsey
    end

    it "returns false when expansion is different" do
      production = Bullock::Parse::Production.new(:symbol, 'expansion')
      other_production = Bullock::Parse::Production.new(:symbol, 'another_expansion')

      expect(production == other_production).to be_falsey
    end

    it "returns true when symbol and expansion are == other production's" do
      production = Bullock::Parse::Production.new(:symbol, 'expansion')
      other_production = Bullock::Parse::Production.new(:symbol, 'expansion')

      expect(production == other_production).to be_truthy
    end
  end
end
