require 'bullock/parse/item_sets_dfa'
require 'bullock/parse/definition'
require 'bullock/parse/grammar'
require 'bullock/parse/symbol'

describe Bullock::Parse::ItemSetsDfa do
  describe "#process" do
    let(:entry_point) { Bullock::Parse::Symbol.new(:__entry_point_start, false) }
    let(:start) { Bullock::Parse::Symbol.new(:start, false) }
    let(:this) { Bullock::Parse::Symbol.new(:this, false) }
    let(:that) { Bullock::Parse::Symbol.new(:that, false) }
    let(:middle) { Bullock::Parse::Symbol.new(:middle, false) }
    let(:stop) { Bullock::Parse::Symbol.new(:stop, false) }

    let(:action) { ->{} }

    describe "generates the dfa" do
      it "for `start -> stop`" do
        definition = Bullock::Parse::Definition.new
        definition.instance_exec do
          production(:start, 'stop') {}
        end
        grammar = Bullock::Parse::Grammar.new(definition, start: :start)

        i0_track_1 = Bullock::Parse::Track.new(entry_point, [start], 0, action)
        i0_track_2 = Bullock::Parse::Track.new(start, [stop], 0, action)
        i0 = Bullock::Parse::ItemSet.new([i0_track_1, i0_track_2])

        i1_track = Bullock::Parse::Track.new(start, [stop], 1, action)
        i1 = Bullock::Parse::ItemSet.new([i1_track])

        i2_track = Bullock::Parse::Track.new(entry_point, [start], 1, action)
        i2 = Bullock::Parse::ItemSet.new([i2_track])

        dfa = Bullock::Parse::ItemSetsDfa.process(grammar)
        is = dfa.item_sets
        expect(dfa.translation_table).to eq ({
          [is.find_index(i0), :stop] => is.find_index(i1),
          [is.find_index(i0), :start] => is.find_index(i2)
        })
      end

      it "for `start -> middle, middle -> stop`" do
        definition = Bullock::Parse::Definition.new
        definition.instance_exec do
          production(:start, 'middle') {}
          production(:middle, 'stop') {}
        end
        grammar = Bullock::Parse::Grammar.new(definition, start: :start)

        i0_track_1 = Bullock::Parse::Track.new(entry_point, [start], 0, action)
        i0_track_2 = Bullock::Parse::Track.new(start, [middle], 0, action)
        i0_track_3 = Bullock::Parse::Track.new(middle, [stop], 0, action)
        i0 = Bullock::Parse::ItemSet.new([i0_track_1, i0_track_2, i0_track_3])

        i1_track = Bullock::Parse::Track.new(start, [middle], 1, action)
        i1 = Bullock::Parse::ItemSet.new([i1_track])

        i2_track = Bullock::Parse::Track.new(entry_point, [start], 1, action)
        i2 = Bullock::Parse::ItemSet.new([i2_track])

        i3_track = Bullock::Parse::Track.new(middle, [stop], 1, action)
        i3 = Bullock::Parse::ItemSet.new([i3_track])

        dfa = Bullock::Parse::ItemSetsDfa.process(grammar)
        is = dfa.item_sets
        expect(dfa.translation_table).to eq({
          [is.find_index(i0), :middle] => is.find_index(i1),
          [is.find_index(i0), :stop] => is.find_index(i3),
          [is.find_index(i0), :start] => is.find_index(i2)
        })
      end

      it "for start -> this that, this -> stop, that -> stop" do
        definition = Bullock::Parse::Definition.new
        definition.instance_exec do
          production(:start, 'this that') {}
          production(:this, 'stop') {}
          production(:that, 'stop') {}
        end
        grammar = Bullock::Parse::Grammar.new(definition, start: :start)

        i0_track_1 = Bullock::Parse::Track.new(entry_point, [start], 0, action)
        i0_track_2 = Bullock::Parse::Track.new(start, [this, that], 0, action)
        i0_track_3 = Bullock::Parse::Track.new(this, [stop], 0, action)
        i0_track_4 = Bullock::Parse::Track.new(that, [stop], 0, action)
        i0 = Bullock::Parse::ItemSet.new([i0_track_1, i0_track_2, i0_track_3, i0_track_4])

        i1_track = Bullock::Parse::Track.new(start, [this, that], 1, action)
        i1 = Bullock::Parse::ItemSet.new([i1_track])

        i2_track = Bullock::Parse::Track.new(entry_point, [start], 1, action)
        i2 = Bullock::Parse::ItemSet.new([i2_track])

        i3_track_1 = Bullock::Parse::Track.new(this, [stop], 1, action)
        i3_track_2 = Bullock::Parse::Track.new(that, [stop], 1, action)
        i3 = Bullock::Parse::ItemSet.new([i3_track_1, i3_track_2])

        i4_track = Bullock::Parse::Track.new(start, [this, that], 2, action)
        i4 = Bullock::Parse::ItemSet.new([i4_track])

        dfa = Bullock::Parse::ItemSetsDfa.process(grammar)
        is = dfa.item_sets
        expect(dfa.translation_table).to eq({
          [is.find_index(i0), :this] => is.find_index(i1),
          [is.find_index(i0), :stop] => is.find_index(i3),
          [is.find_index(i0), :start] => is.find_index(i2),
          [is.find_index(i1), :that] => is.find_index(i4)
        })
      end
    end
  end
end
