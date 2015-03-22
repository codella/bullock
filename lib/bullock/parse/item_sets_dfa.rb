module Bullock
  module Parse
    class ItemSetsDfa
      def process(grammar)
        dfa = []

        item_sets = [ItemSet.create_from_productions(gramma.productions)]
        item_sets.each do |item_set|
          item_set.pointed_symbols.each do |step|
            destination_item_set = item_set.apply(step)
            dfa << [item_set, step, destination_item_set]
            unless item_sets.include? destination_item_set
              item_sets << destination_item_set
            end
          end
        end

        dfa
      end
    end
  end
end