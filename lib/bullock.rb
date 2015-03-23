require 'bullock/lex/rules_collector'
require 'bullock/lex/match_first'

require 'bullock/parse/grammar'
require 'bullock/parse/lalr1'

class Bullock
  class << self
    def lexer(string, **context, &definition)
      rules_collector = Bullock::Lex::RulesCollector.new
      rules_collector.instance_eval(definition)

      Bullock::Lex::MatchFirst.new(rules_collector.rules, string, context)
    end

    def parser(tokens, **context, &definition)
      grammar = Bullock::Parse::Grammar.new(start)
      grammar.instance_eval(definition)

      Bullock::Parse::LALR1.new(grammar, tokens, context)
    end
  end
end
