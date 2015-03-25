module Bullock
  module Parse
    class Track
      attr_reader :symbol, :expansion, :pointer

      def self.from_production(production)
        new(production.symbol, production.expansion, 0)
      end

      def initialize(symbol, expansion, pointer)
        @symbol = symbol
        @expansion = expansion
        @pointer = pointer
      end

      def proceed
        next_pointer = [pointer + 1, expansion.length].min
        self.class.new(symbol, expansion, next_pointer)
      end

      def pointed
        return :EOT unless pointer < expansion.length
        expansion[pointer]
      end

      def ==(other_track)
        symbol == other_track.symbol &&
          expansion == other_track.expansion &&
          pointer == other_track.pointer
      end
    end
  end
end
