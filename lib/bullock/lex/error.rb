module Bullock
  module Lex
    class Error < StandardError
      attr_reader :line, :column, :offset, :context

      def initialize(message, line, column, offset, context)
        @line = line
        @column = column
        @offset = offset
        @context = context
        super(message)
      end
    end
  end
end
