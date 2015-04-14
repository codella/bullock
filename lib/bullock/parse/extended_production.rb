module Bullock
  module Parse
    ExtendedProduction = Struct.new(:expanded, :expansion, :production) do
      extend Forwardable
      def_delegators :expansion, :empty?
      def_delegators :production, :action

      attr_reader :production

      def compare_by_production_and_end_point(other)
      end
    end
  end
end
