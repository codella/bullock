module Bullock
  module Parse
    class ExtendedGrammar
      extend Forwardable
      def_delegators :grammar, :terminals, :non_terminals

      attr_reader :grammar, :start, :productions,
        :entry_point_production

      def initialize(grammar, dfa)
        @grammar = grammar
        @productions = []
        @productions_by_symbol = {}

        item_sets = dfa.item_sets
        tt = dfa.translation_table
        item_sets.each_with_index do |item_set, index|
          item_set.tracks.each do |track|
            next unless track.pointer.zero?

            current_index = index

            expanded = ::Bullock::Parse::ExtendedSymbol.new(
              current_index,
              track.expanded,
              track.expanded.value == grammar.start ? :END : tt[[index, track.expanded.value]]
            )

            expansion = track.expansion.map do |step|
              begin
                next_index = tt[[index, step.value]]
                ::Bullock::Parse::ExtendedSymbol.new(current_index, step, next_index)
              ensure
                current_index = next_index
              end
            end

            production = ::Bullock::Parse::ExtendedProduction.new(expanded, expansion, track.action)

            @productions_by_symbol[expanded] ||= []
            @productions_by_symbol[expanded] << production

            if track.expanded.value == grammar.start
              @entry_point_production = production
              @start = expanded
            end
            productions << production
          end
        end
      end

      def productions_by(symbol)
        @productions_by_symbol[symbol]
      end
    end
  end
end
