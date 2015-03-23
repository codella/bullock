module Bullock
  module Lex
    class Token
      def initialize(outcome, match, line, column, offset, context)
        @token, @value = *normalize_outcome(outcome, match)
        @line = line
        @column = column
        @offset = offset
        @context = context
      end

      attr_reader :token, :value, :line, :column, :offset, :context

      private

      def normalize_outcome(outcome, match)
        case outcome
        when Array
          break outcome if outcome.first.is_a?(Symbol)
          raise "The outcome array must be of type [Symbol, Object]"
        when Symbol
          [outcome, match]
        else
          message = "Outcome must be either a Symbol (the Token) or "
          message << "[Symbol, Object], with Object.to_s being the value to be "
          message << "associated to the Token"
          raise message
        end
      def
    end
  end
end
