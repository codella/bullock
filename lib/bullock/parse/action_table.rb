module Bullock
  module Parse
    class ActionTable
      def initialize(extented_grammar, dfa, follow_set, goto_table)
        @action_table = Hash.new { Hash.new { -> do raise
        end } }

        ::Bullock::Parse::AcceptTable.new.process(dfa.states, @action_table)
        ::Bullock::Parse::ShiftTable.new.process(dfa.transitions, @action_table)
        ::Bullock::Parse::ReduceTable.new.process(
          extended_grammar.productions,
          follow_set,
          goto_table
        )

        dfa.states.each_with_index do |state, index|
          @action_table[index][:EOS] = -> { :accept }
        end

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
          follow_set[production.expanded].each do |symbol|
            @action_table[state][symbol] = -> do
              popped = @stack.pop(production.expansion.length)
              args = popped.map(&:last)
              outcome = production.action.call(*args)
              @stack.push([goto_table(@stack.last.first), outcome])
            end
          end
        end
      end

      def process(tokens)

      end
    end

    class AcceptTable
      def self.process(states, action_table)

      end
    end
  end
end
