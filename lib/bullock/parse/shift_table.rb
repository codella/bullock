module Bullock
  module Parse
    class ShiftTable
      def process(action_table, transitions)
        transitions.select do |key, destination_state|
          symbol = key[1]
          next unless symbol.terminal?
          state = key[0]
          action_table[state][symbol.value] = Proc.new do |stack, shifted|
            stack.push([destination_state, shifted.value])
          end
        end
      end
    end
  end
end
