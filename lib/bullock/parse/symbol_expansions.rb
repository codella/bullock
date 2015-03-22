module Bullock
  module Parse
    class SymbolExpansions
      attr_reader :productions

      def initialize(symbol)
        @symbol = symbol
        @productions = []
      end

      def produces(expansion)
        productions << Production.new(@symbol, expansion)
      end
    end
  end
end
