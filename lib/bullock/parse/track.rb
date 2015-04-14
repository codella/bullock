module Bullock
  module Parse
    class Track
      attr_reader :expanded, :expansion, :pointer, :action

      def self.from_production(production)
        new(production.expanded, production.expansion, 0, production.action)
      end

      def initialize(expanded, expansion, pointer, action)
        @expanded = expanded
        @expansion = expansion
        @pointer = pointer
        @action = action
      end

      def proceed
        next_pointer = [pointer + 1, expansion.length].min
        self.class.new(expanded, expansion, next_pointer, action)
      end

      def pointed
        return EOT unless pointer < expansion.length
        expansion[pointer]
      end

      def ==(other)
        expanded == other.expanded &&
          expansion == other.expansion &&
          pointer == other.pointer
      end

      EOT = ::Bullock::Parse::Symbol.new('EOT')
    end
  end
end
