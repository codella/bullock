require 'bullock/error'

module Bullock
  module Lex
    class Error < Bullock::Error
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
