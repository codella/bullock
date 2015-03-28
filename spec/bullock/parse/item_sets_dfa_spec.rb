require 'bullock/parse/item_sets_dfa'
require 'bullock/parse/definition'
require 'bullock/parse/grammar'
require 'bullock/parse/expansion_symbol'

describe Bullock::Parse::ItemSetsDfa do
  describe "#process" do
    let(:start) { Bullock::Parse::ExpansionSymbol.new(:start, false, false) }
    let(:stop) { Bullock::Parse::ExpansionSymbol.new(:stop, false, false) }

    it "generates the dfa for a single production grammar" do
      definition = Bullock::Parse::Definition.new
      definition.instance_exec do
        production(:start, 'stop') {}
      end
      grammar = Bullock::Parse::Grammar.new(definition, start: :start)

      I0_track_1 = Bullock::Parse::Track.new(:__entry_point_start, [start], 0)
      I0_track_2 = Bullock::Parse::Track.new(:start, [stop], 0)
      I0 = Bullock::Parse::ItemSet.new([I0_track_1, I0_track_2])

      I1_track = Bullock::Parse::Track.new(:start, [stop], 1)
      I1 = Bullock::Parse::ItemSet.new([I1_track])

      I2_track = Bullock::Parse::Track.new(:__entry_point_start, [start], 1)
      I2 = Bullock::Parse::ItemSet.new([I2_track])

      dfa = Bullock::Parse::ItemSetsDfa.process(grammar)
      expect(dfa).to contain_exactly(
        [I0, stop, I1],
        [I0, start, I2]
      )
    end
  end
end
