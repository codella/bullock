module Bullock
  module Parse
    Dfa = Struct.new(:states, :transitions)

    class ItemSetsDfa
      class << self
        def process(grammar)
          transitions = {}

          tracks = grammar.productions.map do |production|
            ::Bullock::Parse::Track.new(production)
          end
          states = [::Bullock::Parse::ItemSet.new(tracks)]
          states.each_with_index do |item_set, index|
            item_set.pointed_symbols.each do |step|
              destination_state = item_set.apply(step)
              destination_index = states.find_index(destination_state)
              if destination_index.nil?
                states << destination_state
                destination_index = states.length - 1
              end
              transitions[[index, step.value]] = destination_index
            end
          end

          ::Bullock::Parse::Dfa.new(states, transitions)
        end
      end
    end
  end
end
