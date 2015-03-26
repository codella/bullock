module Bullock
  module Parse
    class Grammar
      attr_reader :start, :productions

      def initialize(definition, start:)
        @productions = definition.productions
        unless productions.map(&:symbol).include? start
          message = "At least one production must have `:#{start}` on the "
          message << "right-hand side"
          raise message
        end

        @start = "__entry_point_#{start}".to_sym
        productions << Production.new(@start, start.to_s) { |start| start }
      end
    end
  end
end
