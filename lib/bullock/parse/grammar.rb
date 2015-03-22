module Bullock
  module Parse
    class Grammar
      attr_reader :start, :productions

      def initialize(start: :start)
        @start = start
        @productions = []
      end

      def symbol(symbol, &expansions)
        symbol_expansions = SymbolExpansions.new(symbol)
        symbol_expansions.instance_eval(expansions)
        productions.concat(symbol_expansions.productions)
      end

      def production(symbol, expansion)
        productions << Production.new(symbol, expansion)
      end
    end
  end
end
