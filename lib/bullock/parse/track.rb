module Bullock
  module Parse
    class Track
      attr_reader :expanded, :expansion, :pointer

      def self.from_production(production)
        new(production.symbol, production.expansion, 0)
      end

      def initialize(expanded, expansion, pointer)
        @expanded = expanded
        @expansion = expansion
        @pointer = pointer
      end

      def proceed
        next_pointer = [pointer + 1, expansion.length].min
        self.class.new(expanded, expansion, next_pointer)
      end

      def pointed
        return :EOT unless pointer < expansion.length
        expansion[pointer]
      end

      def ==(other_track)
        expanded == other_track.expanded &&
          expansion == other_track.expansion &&
          pointer == other_track.pointer
      end
    end
  end
end
