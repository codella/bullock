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

      def proceed(step)
        return unless step == pointed
        new(symbol, expansion, pointer + 1)
      end

      def pointed
        return :EOT unless pointer < expansion.length
        expansion[pointer]
      end

      private

      attr_reader :expansion, :pointer
    end
  end
end
