require 'bullock/parse/extended_production'
require 'bullock/parse/extended_symbol'

module Bullock
  module Parse
    class ExtendedGrammar
      attr_reader :productions

      def initialize(entry_point, dfa)
        @productions = []

        item_sets = dfa.item_sets
        tt = dfa.translation_table
        item_sets.each_with_index do |item_set, index|
          item_set.tracks.each do |track|
            next unless track.pointer.zero?

            current_index = index

            expanded = ::Bullock::Parse::ExtendedSymbol.new(
              current_index,
              track.expanded,
              track.expanded.symbol == entry_point ? :END : tt[[index, track.expanded.symbol]]
            )

            expansion = track.expansion.map do |step|
              begin
                next_index = tt[[index, step.symbol]]
                ::Bullock::Parse::ExtendedSymbol.new(current_index, step, next_index)
              ensure
                current_index = next_index
              end
            end

            productions << ::Bullock::Parse::ExtendedProduction.new(expanded, expansion, track.action)
          end
        end
      end
    end
  end
end
