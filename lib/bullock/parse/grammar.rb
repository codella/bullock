module Bullock
  module Parse
    class Grammar
      attr_reader :start, :productions

      def initialize(definition, start:)
        @productions = definition.productions
        unless productions.map(&:expanded).map(&:value).include? start
          message = "At least one production must have `:#{start}` on the "
          message << "right-hand side"
          raise message
        end

        @start = "__entry_point_#{start}".to_sym
        @entry_point_production = ::Bullock::Parse::Production.new(@start, start.to_s) { |any| any }
        productions << @entry_point_production
      end

      def terminals
        @terminals ||= productions.map(&:terminals).flatten
      end

      def non_terminals
        @non_terminal ||= begin
          non_terminals = productions.map(&:non_terminals).flatten
          non_terminals << @entry_point_production.expanded
        end
      end
    end
  end
end
