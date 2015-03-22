module Bullock
  module Parse
    class SymbolExpansions
      attr_reader :productions

      def initialize(symbol)
        @symbol = symbol
        @productions = []
      end

      def expands(expansion)
        productions << Production.new(@symbol, expansion)
      end
    end
  end
end
