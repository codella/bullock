require 'bullock/parse/symbol'

module Bullock
  module Parse
    class Track
      attr_reader :expanded, :expansion, :pointer, :action

      def self.from_production(production)
        new(production.expanded, production.expansion, 0, production.action)
      end

      def initialize(expanded, expansion, pointer, action)
        @expanded = expanded
        @expansion = expansion
        @pointer = pointer
        @action = action
      end

      def proceed
        next_pointer = [pointer + 1, expansion.length].min
        self.class.new(expanded, expansion, next_pointer, action)
      end

      def pointed
        return EOT unless pointer < expansion.length
        expansion[pointer]
      end

      def ==(other_track)
        expanded == other_track.expanded &&
          expansion == other_track.expansion &&
          pointer == other_track.pointer
      end

      EOT = ::Bullock::Parse::Symbol.new(:EOT, false, true)
    end
  end
end
