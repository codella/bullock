require 'bullock/parse/production'

describe Bullock::Parse::Production do
  describe ".new" do
    it "creates production with `nil` expansion and no action" do
      production = Bullock::Parse::Production.new(:symbol, nil)

      expect(production.expansion.length).to eq 0
    end

    it "creates production with a single expansion symbol" do
      production = Bullock::Parse::Production.new(:symbol, 'a') {}

      expect(production.expansion.length).to eq 1
    end

    it "creates production with two expansion symbols" do
      production = Bullock::Parse::Production.new(:symbol, 'a b') {}

      expect(production.expansion.length).to eq 2
    end

    it "creates production that by default is not an argument" do
      production = Bullock::Parse::Production.new(:symbol, 'a') {}

      expect(production.expansion.first.argument?).to be_falsey
    end

    it "creates production one symbol to pass as argument" do
      production = Bullock::Parse::Production.new(:symbol, '.a') {}

      expect(production.expansion.first.argument?).to be_truthy
    end

    it "raises an error when right-hand symbol is not a Symbol" do
      expect do
        Bullock::Parse::Production.new('string', 'a?') {}
      end.to raise_error
    end

    it "raises an error when expansion is not present" do
      expect do
        Bullock::Parse::Production.new(:a_symbol, '  ') {}
      end.to raise_error
    end

    it "raises an error when action is not specified for non empty production" do
      expect do
        Bullock::Parse::Production.new(:a_symbol, 'expansion')
      end.to raise_error
    end

    it "raises an error when action is specified for empty production" do
      expect do
        Bullock::Parse::Production.new(:a_symbol, nil) {}
      end.to raise_error
    end
  end

  describe "#==" do
    it "returns false when symbol is different" do
      production = Bullock::Parse::Production.new(:symbol, 'expansion') {}
      other_production = Bullock::Parse::Production.new(:another_symbol, 'expansion') {}

      expect(production == other_production).to be_falsey
    end

    it "returns false when expansion is different" do
      production = Bullock::Parse::Production.new(:symbol, 'expansion') {}
      other_production = Bullock::Parse::Production.new(:symbol, 'another_expansion') {}

      expect(production == other_production).to be_falsey
    end

    it "returns true when symbol and expansion are == other production's" do
      production = Bullock::Parse::Production.new(:symbol, 'expansion') {}
      other_production = Bullock::Parse::Production.new(:symbol, 'expansion') {}

      expect(production == other_production).to be_truthy
    end
  end
end
