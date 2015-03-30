module Bullock
  module Parse
    ExtendedProduction = Struct.new(:expanded, :expansion, :action) do
      def epsilon?
        expansion.empty?
      end

      def ==(other_production)
        expanded == other_production.expanded &&
          expansion == other_production.expansion
      end
    end
  end
end
