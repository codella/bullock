module Bullock
  module Parse
    class Production
      attr_reader :symbol, :expansion, :action

      def initialize(symbol, expansion_string, &action)
        raise "A right-hand side symbol must be specified" unless symbol.is_a? Symbol
        unless expansion_string != nil && expansion_string.strip.length != 0
          raise "An expansion string must be specified"
        end
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
