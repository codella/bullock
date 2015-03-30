module Bullock
  module Parse
    class FirstSet
      class << self
        def make(extended_grammar)
          first_set = {}
          all_symbols = extended_grammar.symbols

          until first_set.length == all_symbols.length
            extended_grammar.production.each do |production|
              
            end
          end
        end
      end
    end
  end
end
