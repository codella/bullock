require 'set'

module Bullock
  module Parse
    class FollowSet
      def process(first_set, grammar)
        follow_set = {}

        follow_set[grammar.start] = Set.new([:END])

        previous_follow_set = nil
        until follow_set == previous_follow_set
          previous_follow_set = follow_set_dup(follow_set)

          grammar.productions.each do |production|
            production.expansion.each_with_index do |step, index|
              next unless step.non_terminal?

              follow_set[step] ||= Set.new

              rest = production.expansion[index+1..-1]
              rest_first_set = first_set_for(rest, first_set)

              follow_set[step] += rest_first_set.reject { |s| s == :EMPTY }
              if rest_first_set.include? :EMPTY
                follow_set[step] += follow_set[production.expanded]
              end
            end
          end
        end

        follow_set
      end

      private

      def first_set_for(symbols, first_set)
        return Set.new([:EMPTY]) if symbols.empty?

        first_set_for_symbols = Set.new

        symbols.each_with_index do |symbol, index|
          first_set_for_symbols += first_set[symbol] - [:EMPTY]
          break unless first_set[symbol].include? :EMPTY
          if index == symbols.length - 1
            first_set_for_symbols << :EMPTY
          end
        end

        first_set_for_symbols
      end

      def follow_set_dup(hash)
        copy = {}

        hash.each do |symbol, set|
          copy[symbol] = Set.new(set)
        end

        copy
      end
    end
  end
end
