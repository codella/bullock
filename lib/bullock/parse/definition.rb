module Bullock
  module Parse
    class Definition
      attr_reader :productions

      def initialize
        @productions = []
      end

      def symbol(symbol, &expansions)
        symbol_expansions = SymbolExpansions.new(symbol)
        symbol_expansions.instance_exec(&expansions)
        productions.concat(symbol_expansions.productions)
      end

      def production(symbol, expansion)
        productions << Production.new(symbol, expansion)
      end
    end
  end
end
