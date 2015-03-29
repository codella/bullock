module Bullock
  module Parse
    class Grammar
      attr_reader :start, :productions

      def initialize(definition, start:)
        @productions = definition.productions
        unless productions.map(&:expanded).map(&:symbol).include? start
          message = "At least one production must have `:#{start}` on the "
          message << "right-hand side"
          raise message
        end

        @start = "__entry_point_#{start}".to_sym
        entry_point = ::Bullock::Parse::Production.new(@start, start.to_s) { |any| any }
        productions << entry_point
      end
    end
  end
end
