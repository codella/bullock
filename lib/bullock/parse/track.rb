module Bullock
  module Parse
    class Track
      def initialize(symbols, pointer)
        @symbols = symbols
        @pointer = pointer
      end

      def proceed(step)
        return unless step == pointed
        new(symbols, pointer + 1)
      end

      # returns `nil` when points over the last symbol
      def pointed
        symbols[pointer]
      end

      def ==(other_track)
        symbols == other_track.symbols &&
          pointer == other_track.pointer
      end

      private

      attr_reader :symbols,  :pointer
    end
  end
end
