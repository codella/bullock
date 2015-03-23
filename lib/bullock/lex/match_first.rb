require 'bullock/lex/environment'
require 'bullock/lex/token'

module Bullock
  module Lex
    class MatchFirst
      def initialize(rules)
        raise "a rule set must be passed" unless rules != nil
        raise "cannot lex without rules" unless rules.any?

        @rules = rules
      end

      def lex(string, **context)
        raise "string cannot be nil" unless string != nil

        scanner = StringScanner.new(string)
        tokens = []
        environment = Bullock::Lex::Environment.new
        line = column = 1
        until scanner.eos?
          catch :matched do
            rules.each do |rule, meta|
              next unless meta[:state] == environment.current_state
              next unless match = scanner.scan(rule)

              matched = match[0]
              number_of_newlines = matched.count("\n")
              line += number_of_newlines
              if number_of_newlines > 0
                column = matched.rpartition("\n").last.length
              else
                column += matched.length
              end
              offset = string.length - scanner.rest.length

              throw :matched unless meta[:action] != nil
              outcome = environment.instance_exec(match, &meta[:action])

              throw :matched unless outcome != nil
              token = Bullock::Lex::Token.new(outcome, matched, line, column, offset, context)
              tokens.push(token)

              throw :matched
            end

            rest = scanner.rest
            rest = rest.length > 5 ? "#{rest[0..5]}..." : rest
            raise "None of the specified rules could match `#{rest}`"
          end
        end
        tokens << Bullock::Lex::Token::EOS
      end

      private

      attr_reader :rules
    end
  end
end
