module Bullock
  module Parse
    class ReduceTable
      def process(action_table, productions, follow_set, goto_table)
        productions.each do |production|
          state = production.final_state
          follow_set[production.expanded].each do |symbol|
            action_table[state][symbol] = Proc.new do |stack|
              popped = stack.pop(production.expansion.length)
              args = popped.map(&:last)
              outcome = production.action.call(*args)
              stack.push([goto_table(stack.last.first), outcome])
            end
          end
        end
      end
    end
  end
end
