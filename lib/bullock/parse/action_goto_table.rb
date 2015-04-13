module Bullock
  module Parse
    class ActionGotoTable
      def initialize(follow_set, extended_grammar, dfa)
        #
        # @action_table = {
        #   [x, symbol] => [-> { @stack.push(state); consume_token }, y]
        #   [x, symbol] => [-> { @stack.push(state); consume_token }, y]
        # }
      end

      def perform(tokens)
        stack = [0]
        # Shift: Denoted by s# (where # is a number) in our table.
        # Push the number, #, onto the set stack.
        # Remove the first character in the string.
        #
        # Reduce: Denoted by r#.
        # Put # into the output.
        # Get the number of tokens on the right-hand side of rule #. Pop that number of states off the stack.
        # There is a new number at the top of the stack. This number is our temporary state. Get the symbol from the left-hand side of the rule #. Treat it as the next input token in the GOTO table (and place the matching state at the top of the set stack).
        #
        # Accept: The input is valid and parsed.
        #
        # Other: Syntax Error
      end
    end
  end
end
