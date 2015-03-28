require 'bullock/parse/track'

module Bullock
  module Parse
    class ItemSet
      attr_reader :tracks

      def self.from_productions(productions)
        tracks = productions.map do |production|
          Track.from_production(production)
        end
        new(tracks)
      end

      def initialize(tracks)
        @tracks = tracks
      end

      def pointed_symbols
        steps = tracks.map(&:pointed).uniq
        steps.delete :EOT
        steps
      end

      def apply(step)
        proceeded_tracks = tracks.map do |track|
          next unless track.pointed.symbol == step.symbol
          track.proceed
        end.compact

        self.class.new(proceeded_tracks)
      end

      def ==(other_item_set)
        unique_tracks = tracks.uniq
        other_unique_tracks = other_item_set.tracks.uniq
        return false unless unique_tracks.length == other_unique_tracks.length
        unique_tracks.all? { |track| other_unique_tracks.include? track }
      end
    end
  end
end
