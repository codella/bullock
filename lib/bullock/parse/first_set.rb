module Bullock
  module Parse
    class FirstSet
      def process(extended_grammar)
        first_set = {}

        extended_grammar.terminals.each do |terminal|
          first_set[terminal] = [terminal]
        end

        compute(extended_grammar.start, extended_grammar, first_set)

        first_set
      end

      private

      def compute(symbol, grammar, first_set)
        first_set[symbol] ||= []
        grammar.productions_by(symbol).each do |production|
          if production.expansion.empty?
            first_set[symbol] << :EMPTYg
            next
          end

          production.expansion.each_with_index do |step, index|
            next unless symbol != step

            if step.terminal?
              first_set[symbol] << step
              break
            end

            unless first_set.key? step
              compute(step, grammar, first_set)
            end

            first_set[symbol] += first_set[step].reject { |value| value == :EMPTY }

            break unless first_set[step].include? :EMPTY

            if index == production.expansion.length - 1
              first_set[symbol] << :EMPTY
            end
          end
        end
        first_set
      end
    end
  end
end
