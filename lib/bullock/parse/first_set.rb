module Bullock
  module Parse
    class FirstSet
      class << self
        def make(extended_grammar)
          first_set = extended_grammar.terminals.inject({}) do |memo, terminal|
            memo[terminal] = terminal
            memo
          end

          first_set.merge extended_grammar.productions.select(&:epsilon?).inject({}) do |memo, production|
            memo[production.expanded] = production.expanded
            memo
          end

          all_symbols = extended_grammar.symbols

          until first_set.length == all_symbols.length
            extended_grammar.productions.each do |production|
              production.expansion.each do |symbol|
                first_set[production.expanded] ||= []
                if symbol.terminal?
                  first_set[production.expanded] << symbol
                  break
                elsif first_set.key? symbol
                  first_set[production.expanded] += first_set[symbol]
                  # handle case of epsilon
                end
              end
            end
          end
        end
      end
    end
  end
end
