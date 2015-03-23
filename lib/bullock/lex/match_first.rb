module Bullock
  module Lex
    class MatchFirst
      def lex(string, rules, **context)
        scanner = StringScanner.new(string)
        tokens = []
        environment = Bullock::Lex::Environment.new
        line = column = 1
        until scanner.eos?
          catch :matched do
            rules.each do |rule, meta|
              next unless meta[:state] == environment.current_state
              next unless match = scanner.scan(rule)
              outcome = environment.instance_eval(match, meta[:action])
              line += match[0].count("\n")
              column += match[0].rpartition("\n").last.length
              offset = input.length - scanner.rest.length
              token = Bullock::Lex::Token.new(outcome, match, line, column, offset, context)
              tokens.push(token)
              throw :matched
            end
            raise "None of the specified rules could match `#{scanner.rest.first(5)}...`"
          end
        end
        tokens << :EOS
      end

      private

      attr_reader :rules
    end
  end
end
