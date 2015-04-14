module Bullock
  module Parse
    class GotoTable
      def initialize(translation_table)
        @goto_table = translation_table.select do |key, value|
          symbol = key[1]
          symbol.non_terminal?
        end
      end

      def goto(*args)
        @goto_table.fetch(*args)
      end
    end
  end
end
