module Bullock
  module Lex
    class Environment
      def initialize
        @states = []
      end

      def current_state
        states.last
      end

      def push_state(state)
        states.push(state)
      end

      def pop_state
        raise "There's no state on the stack" unless states.any?
        states.pop
      end

      private

      attr_reader :states
    end
  end
end
