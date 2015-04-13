module Bullock
  module Parse
    class GotoTable
      def initialize(translation_table)
        @goto_table = translation_table.select do |key, value|
          key.second.non_terminal?
        end
      end

      def goto(*args)
        @goto_table[*args]
      end
    end
  end
end
