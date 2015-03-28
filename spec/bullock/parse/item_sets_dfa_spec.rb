require 'bullock/parse/item_sets_dfa'
require 'bullock/parse/definition'
require 'bullock/parse/grammar'
require 'bullock/parse/expansion_symbol'

describe Bullock::Parse::ItemSetsDfa do
  describe "#process" do
    let(:start) { Bullock::Parse::ExpansionSymbol.new(:start, false, false) }
    let(:middle) { Bullock::Parse::ExpansionSymbol.new(:middle, false, false) }
    let(:stop) { Bullock::Parse::ExpansionSymbol.new(:stop, false, false) }

    describe "generates the dfa" do
      it "for a single production grammar" do
        definition = Bullock::Parse::Definition.new
        definition.instance_exec do
          production(:start, 'stop') {}
        end
        grammar = Bullock::Parse::Grammar.new(definition, start: :start)

        i0_track_1 = Bullock::Parse::Track.new(:__entry_point_start, [start], 0)
        i0_track_2 = Bullock::Parse::Track.new(:start, [stop], 0)
        i0 = Bullock::Parse::ItemSet.new([i0_track_1, i0_track_2])

        i1_track = Bullock::Parse::Track.new(:start, [stop], 1)
        i1 = Bullock::Parse::ItemSet.new([i1_track])

        i2_track = Bullock::Parse::Track.new(:__entry_point_start, [start], 1)
        i2 = Bullock::Parse::ItemSet.new([i2_track])

        dfa = Bullock::Parse::ItemSetsDfa.process(grammar)
        expect(dfa.translation_table).to contain_exactly(
          [i0, stop, i1],
          [i0, start, i2]
        )
      end

      it "for grammar with a production and a subsequent one" do
        definition = Bullock::Parse::Definition.new
        definition.instance_exec do
          production(:start, 'middle') {}
          production(:middle, 'stop') {}
        end
        grammar = Bullock::Parse::Grammar.new(definition, start: :start)

        i0_track_1 = Bullock::Parse::Track.new(:__entry_point_start, [start], 0)
        i0_track_2 = Bullock::Parse::Track.new(:start, [middle], 0)
        i0_track_3 = Bullock::Parse::Track.new(:middle, [stop], 0)
        i0 = Bullock::Parse::ItemSet.new([i0_track_1, i0_track_2, i0_track_3])

        i1_track = Bullock::Parse::Track.new(:start, [middle], 1)
        i1 = Bullock::Parse::ItemSet.new([i1_track])

        i2_track = Bullock::Parse::Track.new(:__entry_point_start, [start], 1)
        i2 = Bullock::Parse::ItemSet.new([i2_track])

        i3_track = Bullock::Parse::Track.new(:middle, [stop], 1)
        i3 = Bullock::Parse::ItemSet.new([i3_track])

        dfa = Bullock::Parse::ItemSetsDfa.process(grammar)
        expect(dfa.translation_table).to contain_exactly(
          [i0, middle, i1],
          [i0, stop, i3],
          [i0, start, i2]
        )
      end
    end
  end
end
