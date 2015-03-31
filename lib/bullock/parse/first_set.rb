module Bullock
  module Parse
    class FirstSet
      def process(extended_grammar)
        first_set = extended_grammar.terminals.inject({}) do |memo, terminal|
          memo[terminal] = [terminal]
          memo
        end

        with_empty_expansion = extended_grammar.productions.select(&:empty?).map do |production|
          production.expanded
        end
byebug
        compute(extended_grammar.start, extended_grammar, first_set, with_empty_expansion)
      end

      def compute(symbol, grammar, first_set, with_empty_expansion)
        grammar.productions_by(symbol).each do |production|
          first_set[symbol] ||= []
          production.expansion.each do |step|
            next unless symbol != step
            if step.terminal?
              first_set[symbol] << step
              return
            end
            unless first_set.key? step
              first_set[step] = compute(step, grammar, first_set, with_empty_expansion)
            end
            first_set[production.expanded] += first_set[symbol]
            return unless with_empty_expansion.include? symbol
          end
        end
      end
    end
  end
end
