module Bullock
  module Parse
    class Track
      def self.from_production(production)
        new(prodcution.non_terminal, production.expansion, 0)
      end

      def initialize(non_terminal, expansion, pointer)
        @non_terminal = non_terminal
        @expansion = expansion
        @pointer = pointer
      end

      def proceed(step)
        return unless step == pointed
        new(non_terminal, expansion, pointer + 1)
      end

      def pointed
        return :EOT unless pointer < symbols.length
        symbols[pointer]
      end

      private

      attr_reader :symbols,  :pointer
    end
  end
end
