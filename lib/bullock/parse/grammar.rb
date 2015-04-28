module Bullock
  module Parse
    class Grammar
      attr_reader :start, :productions

      def initialize(start, productions)
        unless productions.map(&:expanded).map(&:value).include? start
          message = "At least one production must expand `:#{start}`"
          raise message
        end

        @start = "#{::Bullock::Parse::Symbol::ENTRY_POINT_PREFIX}_#{start}".to_sym
        @goal = ::Bullock::Parse::Production.new(@start, start.to_s) { |any| any }
        productions << @goal
        @productions = productions
      end

      def terminals
        @terminals ||= productions.map(&:terminals).flatten
      end

      def non_terminals
        @non_terminal ||= begin
          non_terminals = productions.map(&:non_terminals).flatten
          non_terminals << @goal.expanded
        end
      end
    end
  end
end
