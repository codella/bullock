require 'bullock/parse/item_set'
require 'bullock/parse/definition'
require 'bullock/parse/symbol'
require 'bullock/parse/grammar'
require 'bullock/parse/track'

describe Bullock::Parse::ItemSet do
  let(:a_track) do
    a_symbol = Bullock::Parse::Symbol.new(:a_symbol, false, false)
    Bullock::Parse::Track.new(a_symbol, [
      Bullock::Parse::Symbol.new(:X, false, false),
      Bullock::Parse::Symbol.new(:Y, false, false)
    ], 0)
  end

  let(:another_track) do
    another_symbol = Bullock::Parse::Symbol.new(:another_symbol, false, false)
    Bullock::Parse::Track.new(another_symbol, [
      Bullock::Parse::Symbol.new(:A, false, false),
      Bullock::Parse::Symbol.new(:B, false, false)
    ], 0)
  end

  describe ".from_productions" do
    let(:grammar) do
      definition = Bullock::Parse::Definition.new
      definition.instance_exec do
        production(:a_symbol, 'X Y') {}
        production(:another_symbol, 'A B') {}
      end

      Bullock::Parse::Grammar.new(definition, start: :a_symbol)
    end

    it "creates an item set with given tracks" do
      item_set_from_productions = Bullock::Parse::ItemSet.from_productions(
        grammar.productions
      )

      entry_point = Bullock::Parse::Symbol.new(:__entry_point_a_symbol, false, false)
      entry_point_track = Bullock::Parse::Track.new(entry_point, [
        Bullock::Parse::Symbol.new(:a_symbol, false, false)
      ], 0)
      expected_tracks = [a_track, another_track, entry_point_track]
      expected_item_set = Bullock::Parse::ItemSet.new(expected_tracks)

      expect(item_set_from_productions).to eq expected_item_set
    end
  end

  describe "#apply" do
    it "creates a new item set given a symbol" do
      item_set = Bullock::Parse::ItemSet.new([a_track, another_track])

      a_symbol = Bullock::Parse::Symbol.new(:a_symbol, false, false)
      expected_track = Bullock::Parse::Track.new(a_symbol, [
        Bullock::Parse::Symbol.new(:X, false, false),
        Bullock::Parse::Symbol.new(:Y, false, false)
      ], 1)
      expected_item_set = Bullock::Parse::ItemSet.new([expected_track])

      step = Bullock::Parse::Symbol.new(:X, false, false)
      expect(item_set.apply(step)).to eq expected_item_set
    end
  end

  describe "#pointed_symbols" do
    it "returns the pointed symbols" do
      a_track = Bullock::Parse::Track.new(:any, [
        Bullock::Parse::Symbol.new(:X, false, false),
        Bullock::Parse::Symbol.new(:Y, false, false)
      ], 1)
      another_track = Bullock::Parse::Track.new(:any, [
        Bullock::Parse::Symbol.new(:X, false, false),
        Bullock::Parse::Symbol.new(:Y, false, false)
      ], 0)
      item_set = Bullock::Parse::ItemSet.new([a_track, another_track])

      expect(item_set.pointed_symbols).to contain_exactly(
        Bullock::Parse::Symbol.new(:X, false, false),
        Bullock::Parse::Symbol.new(:Y, false, false)
      )
    end
  end

  describe "#==" do
    it "returns true when tracks coincides" do
      item_set = Bullock::Parse::ItemSet.new([
        Bullock::Parse::Track.new(:symbol, [
          Bullock::Parse::Symbol.new(:X, false, false)
        ], 0)
      ])

      equal_item_set = Bullock::Parse::ItemSet.new([
        Bullock::Parse::Track.new(:symbol, [
          Bullock::Parse::Symbol.new(:X, false, false)
        ], 0)
      ])

      expect(item_set == equal_item_set).to be_truthy
    end

    it "returns false when tracks differs" do
      item_set = Bullock::Parse::ItemSet.new([
        Bullock::Parse::Track.new(:symbol, [
          Bullock::Parse::Symbol.new(:X, false, false)
        ], 0)
      ])

      different_item_set = Bullock::Parse::ItemSet.new([
        Bullock::Parse::Track.new(:symbol, [
          Bullock::Parse::Symbol.new(:Y, true, true)
        ], 1)
      ])

      expect(item_set == different_item_set).to be_falsey
    end
  end
end
