module Bullock
  module Parse
    class ItemSetsDfa
      class << self
        def process(grammar)
          translation_table = {}

          item_sets = [Bullock::Parse::ItemSet.from_productions(grammar.productions)]
          item_sets.each_with_index do |item_set, index|
            item_set.pointed_symbols.each do |step|
              destination_item_set = item_set.apply(step)
              destination_index = item_sets.find_index(destination_item_set)
              if destination_index.nil?
                item_sets << destination_item_set
                destination_index = item_sets.length - 1
              end
              translation_table[[index, step.value]] = destination_index
            end
          end

          ::Bullock::Parse::Dfa.new(item_sets, translation_table)
        end
      end
    end
  end
end
