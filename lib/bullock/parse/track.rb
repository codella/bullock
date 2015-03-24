module Bullock
  module Parse
    class Track
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
        Bullock::Parse::Track.new(symbol, expansion, next_pointer)
      end

      def pointed
        return :EOT unless pointer < expansion.length
        expansion[pointer]
      end

      private

      attr_reader :symbol, :expansion, :pointer
    end
  end
end
