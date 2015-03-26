module Bullock
  module Parse
    class Production
      attr_reader :symbol, :expansion, :action

      def initialize(symbol, expansion_string, &action)
        raise "Productions must have an associated action" unless action != nil

        @symbol = symbol
        @expansion = create_expansion(expansion_string)
        @action = action
      end

      def ==(other_production)
        symbol == other_production.symbol &&
          expansion == other_production.expansion
      end

      private

      def create_expansion(expansion_string)
        expansions = expansion_string.split(' ')
        raise "Productions cannot have empty expansion" unless expansions.any?

        expansions.map do |symbol_string|
          match = /(\.?)(\w+)(\??)/.match(symbol_string)
          {
            symbol: match[2].to_sym,
            argument: match[1] == '.',
            optional: match[3] == '?'
          }
        end
      end
    end
  end
end
