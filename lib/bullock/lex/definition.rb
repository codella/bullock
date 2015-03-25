module Bullock
  module Lex
    class Definition
      attr_reader :rules

      def initialize
        @rules = {}
      end

      def rule(regex, state = :base, &action)
        rules[regex.freeze] = { state: state, action: action }
      end
    end
  end
end
