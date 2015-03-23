module Bullock
  module Parse
    class Grammar
      attr_reader :start, :productions

      def initialize
        @productions = []
      end

      def start
        return if productions.empty?
        @start || productions.first.symbol
      end

      def start_from(symbol)
        raise "Start point must be a Symbol" unless symbol.is_a? Symbol
        @start = symbol
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
