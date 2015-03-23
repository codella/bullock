module Bullock
  module Lex
    class Environment
      def initialize
        @states = [:base]
      end

      def current_state
        states.last
      end

      def push_state(state)
        states.push(state)
      end

      def pop_state
        raise "There's no state on the stack" unless states != [:base]
        states.pop
      end

      private

      attr_reader :states
    end
  end
end
