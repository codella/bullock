describe Bullock::Parse::ItemSetsDfa do
  describe "#process" do
    let(:entry_point) { Bullock::Parse::Symbol.new('__entry_point_start') }
    let(:start) { Bullock::Parse::Symbol.new('start') }
    let(:this) { Bullock::Parse::Symbol.new('this') }
    let(:that) { Bullock::Parse::Symbol.new('that') }
    let(:middle) { Bullock::Parse::Symbol.new('middle') }
    let(:stop) { Bullock::Parse::Symbol.new('stop') }

    let(:action) { ->{} }

    describe "generates the dfa" do
      it "for `start -> stop`" do
        production_1 = Bullock::Parse::Production.new(:entry_point, 'start', &action)
        production_2 = Bullock::Parse::Production.new(:start, 'stop', &action)

        i0_track_1 = Bullock::Parse::Track.new(production_1, 0)
        i0_track_2 = Bullock::Parse::Track.new(production_2, 0)
        i0 = Bullock::Parse::ItemSet.new([i0_track_1, i0_track_2])

        i1_track = Bullock::Parse::Track.new(production_2, 1)
        i1 = Bullock::Parse::ItemSet.new([i1_track])

        i2_track = Bullock::Parse::Track.new(production_1, 1)
        i2 = Bullock::Parse::ItemSet.new([i2_track])

        grammar = double(:grammar, productions: [production_1, production_2], start: :entry_point)

        dfa = Bullock::Parse::ItemSetsDfa.process(grammar)
        expect(dfa.transitions).to eq ({
          [0, start] => 1,
          [0, stop] => 2
        })
      end

      it "for `start -> middle, middle -> stop`" do
        production_1 = Bullock::Parse::Production.new(:entry_point, 'start', &action)
        production_2 = Bullock::Parse::Production.new(:start, 'middle', &action)
        production_3 = Bullock::Parse::Production.new(:middle, 'stop', &action)

        i0_track_1 = Bullock::Parse::Track.new(production_1, 0)
        i0_track_2 = Bullock::Parse::Track.new(production_2, 0)
        i0_track_3 = Bullock::Parse::Track.new(production_2, 0)
        i0 = Bullock::Parse::ItemSet.new([i0_track_1, i0_track_2, i0_track_3])

        i1_track = Bullock::Parse::Track.new(production_2, 1)
        i1 = Bullock::Parse::ItemSet.new([i1_track])

        i2_track = Bullock::Parse::Track.new(production_1, 1)
        i2 = Bullock::Parse::ItemSet.new([i2_track])

        i3_track = Bullock::Parse::Track.new(production_3, 1)
        i3 = Bullock::Parse::ItemSet.new([i3_track])

        grammar = double(:grammar, start: :entry_point, productions: [
          production_1, production_2, production_3
        ])

        dfa = Bullock::Parse::ItemSetsDfa.process(grammar)
        expect(dfa.transitions).to eq({
          [0, middle] => 2,
          [0, stop] => 3,
          [0, start] => 1
        })
      end

      it "for start -> this that, this -> stop, that -> stop" do
        production_1 = Bullock::Parse::Production.new(:entry_point, 'start', &action)
        production_2 = Bullock::Parse::Production.new(:start, 'this that', &action)
        production_3 = Bullock::Parse::Production.new(:this, 'stop', &action)
        production_4 = Bullock::Parse::Production.new(:that, 'stop', &action)

        i0_track_1 = Bullock::Parse::Track.new(production_1, 0)
        i0_track_2 = Bullock::Parse::Track.new(production_2, 0)
        i0_track_3 = Bullock::Parse::Track.new(production_3, 0)
        i0_track_4 = Bullock::Parse::Track.new(production_4, 0)
        i0 = Bullock::Parse::ItemSet.new([i0_track_1, i0_track_2, i0_track_3, i0_track_4])

        i1_track = Bullock::Parse::Track.new(production_2, 1)
        i1 = Bullock::Parse::ItemSet.new([i1_track])

        i2_track = Bullock::Parse::Track.new(production_1, 1)
        i2 = Bullock::Parse::ItemSet.new([i2_track])

        i3_track_1 = Bullock::Parse::Track.new(production_3, 1)
        i3_track_2 = Bullock::Parse::Track.new(production_4, 1)
        i3 = Bullock::Parse::ItemSet.new([i3_track_1, i3_track_2])

        i4_track = Bullock::Parse::Track.new(production_2, 2)
        i4 = Bullock::Parse::ItemSet.new([i4_track])

        grammar = double(:grammar, start: :entry_point, productions: [
          production_1, production_2, production_3, production_4
        ])

        dfa = Bullock::Parse::ItemSetsDfa.process(grammar)
        expect(dfa.transitions).to eq({
          [0, this] => 2,
          [0, stop] => 3,
          [0, start] => 1,
          [2, that] => 4
        })
      end
    end
  end
end
