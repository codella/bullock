module Bullock
  module Parse
    class ItemSet
      attr_reader :tracks

      def initialize(tracks)
        @tracks = tracks
      end

      def pointed_symbols
        steps = tracks.map(&:pointed).uniq
        steps.delete ::Bullock::Parse::Track::EOT
        steps
      end

      def apply(step)
        proceeded_tracks = tracks.map do |track|
          next unless track.pointed.value == step.value
          track.proceed
        end.compact

        self.class.new(proceeded_tracks)
      end

      def ==(other)
        unique_tracks = tracks.uniq
        other_unique_tracks = other.tracks.uniq
        return false unless unique_tracks.length == other_unique_tracks.length
        unique_tracks.all? { |track| other_unique_tracks.include? track }
      end
    end
  end
end
