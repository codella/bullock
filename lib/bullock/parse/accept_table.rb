module Bullock
  module Parse
    class AcceptTable
      def process(action_table, states)
        states.each_with_index do |state, index|
          next unless state.is_accepting
          action_table[index][:EOS] = -> { :accept }
        end
      end
    end
  end
end
