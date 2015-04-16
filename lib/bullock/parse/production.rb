module Bullock
  module Parse
    class Production
      attr_reader :expanded, :expansion, :action, :terminals, :non_terminals

      def initialize(symbol, expansion_string, &block)
        raise "A right-hand side symbol must be specified" unless symbol.is_a? ::Symbol
        unless expansion_string == nil || expansion_string.strip.length != 0
          raise "An expansion must be either `nil` ar a non empty string"
        end

        expansion_with_action = expansion_string != nil && block != nil
        no_expansion_with_no_action = expansion_string == nil && block == nil

        unless expansion_with_action || no_expansion_with_no_action
          message = "Productions must have either a non empty expansion with "
          message << "an associated action, or `nil` expansion with no action "
          message << "associated."
          raise message
        end

        @expanded = ::Bullock::Parse::Symbol.new(symbol)
        @expansion = create_expansion(expansion_string)
        @terminals, @non_terminals = @expansion.partition(&:terminal?)
        @action = block
      end

      def entry_point?
        expanded.entry_point?
      end

      def ==(other_production)
        expanded == other_production.expanded &&
          expansion == other_production.expansion
      end

      private

      def create_expansion(expansion_string)
        return [] unless expansion_string != nil

        expansions = expansion_string.split(' ')
        raise "Productions cannot have empty expansion" unless expansions.any?

        expansions.map { |symbol| ::Bullock::Parse::Symbol.new(symbol) }
      end
    end
  end
end
