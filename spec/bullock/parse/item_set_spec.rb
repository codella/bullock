describe Bullock::Parse::ItemSet do
  let(:a_symbol) { Bullock::Parse::Symbol.new('a_symbol') }
  let(:another_symbol) { Bullock::Parse::Symbol.new('another_symbol') }
  let(:a) { Bullock::Parse::Symbol.new('a') }
  let(:b) { Bullock::Parse::Symbol.new('b') }
  let(:x) { Bullock::Parse::Symbol.new('x') }
  let(:y) { Bullock::Parse::Symbol.new('y') }

  let(:a_track) do
    production = Bullock::Parse::Production.new(:a_symbol, 'x y', &action)
    Bullock::Parse::Track.new(production, 0)
  end

  let(:another_track) do
    production = Bullock::Parse::Production.new(:another_symbol, 'a b', &action)
    Bullock::Parse::Track.new(production, 0)
  end

  let(:action) { ->{} }

  describe "#apply" do
    it "creates a new item set given a symbol" do
      item_set = Bullock::Parse::ItemSet.new([a_track, another_track])

      production = Bullock::Parse::Production.new(:a_symbol, 'x y', &action)
      expected_track = Bullock::Parse::Track.new(production, 1)
      expected_item_set = Bullock::Parse::ItemSet.new([expected_track])

      expect(item_set.apply(x)).to eq expected_item_set
    end
  end

  describe "#pointed_symbols" do
    it "returns the pointed symbols" do
      production = Bullock::Parse::Production.new(:any, 'x y', &action)

      a_track = Bullock::Parse::Track.new(production, 1)

      another_production = Bullock::Parse::Production.new(:any, 'x y', &action)
      another_track = Bullock::Parse::Track.new(production, 0)
      item_set = Bullock::Parse::ItemSet.new([a_track, another_track])

      expect(item_set.pointed_symbols).to contain_exactly(x, y)
    end
  end

  describe "#==" do
    it "returns true when tracks coincides" do
      production = Bullock::Parse::Production.new(:a_symbol, 'x y', &action)
      track = Bullock::Parse::Track.new(production, 0)
      item_set = Bullock::Parse::ItemSet.new([track])

      equal_production = Bullock::Parse::Production.new(:a_symbol, 'x y', &action)
      equal_track = Bullock::Parse::Track.new(equal_production, 0)
      equal_item_set = Bullock::Parse::ItemSet.new([equal_track])

      expect(item_set == equal_item_set).to be_truthy
    end

    it "returns false when tracks differs" do
      production = Bullock::Parse::Production.new(:a_symbol, 'x', &action)
      track = Bullock::Parse::Track.new(production, 0)
      item_set = Bullock::Parse::ItemSet.new([track])

      different_production = Bullock::Parse::Production.new(:a_symbol, 'y', &action)
      different_track = Bullock::Parse::Track.new(different_production, 1)
      different_item_set = Bullock::Parse::ItemSet.new([different_track])

      expect(item_set == different_item_set).to be_falsey
    end
  end
end
