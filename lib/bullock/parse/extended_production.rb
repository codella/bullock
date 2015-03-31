require 'forwardable'

module Bullock
  module Parse
    ExtendedProduction = Struct.new(:expanded, :expansion, :action) do
      extend Forwardable
      def_delegators :expansion, :empty?

      def ==(other_production)
        expanded == other_production.expanded &&
          expansion == other_production.expansion
      end
    end
  end
end
