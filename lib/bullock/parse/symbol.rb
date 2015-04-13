module Bullock
  module Parse
    Symbol = Struct.new(:value, :argument?, :terminal?) do
      def non_terminal?
        not terminal?
      end

      def ==(other_symbol)
        value == other_symbol.value
      end
    end
  end
end
