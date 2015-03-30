module Bullock
  module Parse
    Symbol = Struct.new(:symbol, :argument?, :terminal?) do
      def non_terminal?
        not terminal?
      end

      def ==(other_symbol)
        symbol == other_symbol.symbol
      end
    end
  end
end
