require 'bullock/parse/production'
require 'bullock/parse/symbol_expansions'

module Bullock
  module Parse
    class Definition
      attr_reader :productions

      def initialize
        @productions = []
      end

      def symbol(symbol, &expansions)
        symbol_expansions = ::Bullock::Parse::SymbolExpansions.new(symbol)
        symbol_expansions.instance_exec(&expansions)
        productions.concat(symbol_expansions.productions)
      end

      def production(symbol, expansion, &action)
        productions << ::Bullock::Parse::Production.new(symbol, expansion, &action)
      end
    end
  end
end
