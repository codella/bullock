module Bullock
  module Parse
    class Symbol
      ENTRY_POINT_PREFIX = '__bullock_entry_point_symbol'

      attr_reader :value

      def initialize(symbol)
        match = /(\.?)(\w+)/.match(symbol.to_s)

        upcase = match[2] == match[2].upcase
        downcase = match[2] == match[2].downcase

        raise "`#{string}` must be either upcased or downcased" unless upcase || downcase

        @value = match[2].to_sym
        @is_argument = match[1] == '.'
        @is_terminal = upcase
      end

      def terminal?
        @is_terminal
      end

      def non_terminal?
        not @is_terminal
      end

      def argument?
        @is_argument
      end

      def entry_point?
        value.to_s.start_with? ENTRY_POINT_PREFIX
      end

      def ==(other)
        value == other.value
      end

      def eql?(other)
        self == other
      end

      def hash
        value.hash
      end
    end
  end
end
