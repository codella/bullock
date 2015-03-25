require 'bullock/parse/item_set'
require 'bullock/parse/definition'
require 'bullock/parse/grammar'
require 'bullock/parse/track'

describe Bullock::Parse::ItemSet do
  let(:a_track) do
    Bullock::Parse::Track.new(:a_symbol, [
      {
        symbol: :X,
        argument: false,
        optional: false
      }, {
        symbol: :Y,
        argument: false,
        optional: false
      }
    ], 0)
  end

  let(:another_track) do
    Bullock::Parse::Track.new(:another_symbol, [
      {
        symbol: :A,
        argument: false,
        optional: false
      }, {
        symbol: :B,
        argument: false,
        optional: false
      }
    ], 0)
  end

  describe ".from_productions" do
    let(:grammar) do
      definition = Bullock::Parse::Definition.new
      definition.instance_exec do
        production(:a_symbol, 'X Y')
        production(:another_symbol, 'A B')
      end

      Bullock::Parse::Grammar.new(definition, start: :a_symbol)
    end

    it "creates an item set with given tracks" do
      item_set_from_productions = Bullock::Parse::ItemSet.from_productions(
        grammar.productions
      )

      entry_point_track = Bullock::Parse::Track.new(:__entry_point_a_symbol, [
          {
            symbol: :a_symbol,
            argument: false,
            optional: false
          }
        ], 0
      )
      expected_tracks = [entry_point_track, a_track, another_track]
      expected_item_set = Bullock::Parse::ItemSet.new(expected_tracks)

      expect(item_set_from_productions).to eq expected_item_set
    end
  end

  describe "#apply" do
    it "creates a new item set given a symbol" do
      item_set = Bullock::Parse::ItemSet.new([a_track, another_track])

      expected_track = Bullock::Parse::Track.new(:a_symbol, [
        {
          symbol: :X,
          argument: false,
          optional: false
        }, {
          symbol: :Y,
          argument: false,
          optional: false
        }], 1)
      expected_item_set = Bullock::Parse::ItemSet.new([expected_track])

      expect(item_set.apply(:X)).to eq expected_item_set
    end
  end

  describe "#pointed_symbols" do
  end

  describe "#==" do
  end
end
