module Bullock
  module Parse
    class Production
      attr_reader :symbol, :expansion

      def initialize(symbol, expansion)
        @symbol = symbol
        @expansion = expansion
      end

      def ==(other_production)
        symbol == other_production.symbol &&
          expansion == other_production.expansion
      end
    end
  end
end
