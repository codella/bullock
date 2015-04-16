module Bullock
  module Parse
    class Track
      extend Forwardable
      def_delegators :production, :expanded, :expansion, :action

      attr_reader :production, :pointer

      def initialize(production, pointer = 0)
        @production = production
        @pointer = pointer
      end

      def proceed
        next_pointer = [pointer + 1, expansion.length].min
        self.class.new(production, next_pointer)
      end

      def pointed
        return EOT unless pointer < expansion.length
        expansion[pointer]
      end

      def eot?
        pointed == EOT
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
