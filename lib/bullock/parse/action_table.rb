module Bullock
  module Parse
    class ActionTable
      def initialize(extented_grammar, dfa, follow_set, goto_table)
        @action_table = {}

        @action_table[][] = -> { :accept }

        dfa.transitions.select do |key, destination_state|
          symbol = key[1]
          next unless symbol.terminal?
          state = key[0]
          @action_table[state][symbol] = -> do
            shifted = tokens.shift
            @stack.push([destination_state, shifted.value])
          end
        end

        extended_grammar.productions.each do |production|
          state = production.final_state
          symbol = production.expanded
          @action_table[state][symbol] = -> do
            popped = @stack.pop(production.expansion.length)
            args = popped.map(&:last)
            outcome = production.action.call(*args)
            @stack.push([goto_table(@stack.last.first), outcome])
          end
        end
      end

      def process(tokens)

      end
    end
  end
end
