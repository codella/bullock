require 'bullock/parse/item_set'
require 'bullock/parse/dfa'

module Bullock
  module Parse
    class ItemSetsDfa
      class << self
        def process(grammar)
          translation_table = []

          item_sets = [Bullock::Parse::ItemSet.from_productions(grammar.productions)]
          item_sets.each do |item_set|
            item_set.pointed_symbols.each do |step|
              destination_item_set = item_set.apply(step)
              translation_table << [item_set, step, destination_item_set]
              unless item_sets.include? destination_item_set
                item_sets << destination_item_set
              end
            end
          end

          Bullock::Parse::Dfa.new(item_sets, translation_table)
        end
      end
    end
  end
end
