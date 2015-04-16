module Bullock
  module Parse
    ExtendedProduction = Struct.new(:expanded, :expansion, :production) do
      extend Forwardable
      def_delegators :expansion, :empty?
      def_delegators :production, :action

      attr_reader :production

      def final_state
        expansion.last.next
      end
    end
  end
end
