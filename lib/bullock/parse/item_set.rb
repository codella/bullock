module Bullock
  module Parse
    class ItemSet
      def self.create_from_productions(productions)
      end

      def initialize(tracks)
        @tracks = tracks
      end

      def pointed_symbols
        tracks.map(&:pointed)
      end

      def apply(step)
        proceeded_tracks = tracks.map do |track|
          track.proceed(step)
        end
        new(proceeded_tracks)
      end

      def ==(other_item_set)
        tracks == other_item_set.tracks
      end

      private

      attr_reader :tracks
    end
  end
end