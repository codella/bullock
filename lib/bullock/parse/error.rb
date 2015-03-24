module Bullock
  module Parse
    class Error < StandardError
      attr_reader :line, :column, :length, :offset, :context
      
      def initialize(message, line, column, length, offset, context)
        @line = line
        @column = column
        @length = length
        @offset = offset
        @context = context
        super(message)
      end
    end
  end
end
