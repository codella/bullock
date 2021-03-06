module Bullock
  module Parse
    class SymbolExpansions
      attr_reader :productions

      def initialize(symbol)
        @symbol = symbol
        @productions = []
      end

      def produces(expansion, &action)
        productions << Bullock::Parse::Production.new(@symbol, expansion, &action)
      end
    end
  end
end
