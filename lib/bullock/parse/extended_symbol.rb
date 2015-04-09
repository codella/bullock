require 'forwardable'

module Bullock
  module Parse
    ExtendedSymbol = Struct.new(:current, :symbol, :next) do
      extend Forwardable
      def_delegators :symbol, :argument?, :terminal?, :non_terminal?
    end
  end
end
