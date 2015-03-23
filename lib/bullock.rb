require 'bullock/lex/match_first'
require 'bullock/parse/lalr1'

class Bullock
  class << self
    def lexer(string, **context, &definition)
      lexer_definition = Bullock::Lex::Definition.new
      lexer_definition.instance_eval(definition)

      Bullock::Lex::MatchFirst.new(lexer_definition.rules, string, context)
    end

    def parser(tokens, **context, &definition)
      grammar = Bullock::Parse::Grammar.new(start)
      grammar.instance_eval(definition)

      Bullock::Parse::LALR1.new(grammar, tokens, context)
    end
  end
end
