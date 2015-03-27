module Bullock
  module Lex
    class Token

      attr_reader :regexp, :token, :value, :line, :column, :length, :offset, :context

      def initialize(regexp, outcome, match, line, column, length, offset, context)
        @regexp = regexp
        @token, @value = *normalize_outcome(outcome, match)
        @line = line
        @column = column
        @length = length
        @offset = offset
        @context = context
      end

      private

      def normalize_outcome(outcome, match)
        case outcome
        when Array
          return outcome if outcome.first.is_a?(Symbol)
          raise "The outcome array must be of type [Symbol, Object]"
        when Symbol
          [outcome, match]
        else
          message = "Outcome must be either a Symbol (the Token) or "
          message << "[Symbol, Object], with Object.to_s being the value to be "
          message << "associated to the Token"
          raise message
        end
      end

      EOS = new(nil, :EOS, nil, nil, nil, nil, nil, nil)
    end
  end
end
