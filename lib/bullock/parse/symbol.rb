module Bullock
  module Parse
    Symbol = Struct.new(:symbol, :argument?, :terminal?, :non_terminal?) do
      def ==(other_symbol)
        symbol == other_symbol.symbol
      end
    end
  end
end
