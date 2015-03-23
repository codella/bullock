require 'bullock/lex/lexer'
require 'bullock/parse/lalr1'

class Bullock
  class << self
    def lexer(string, &definition)
      Bullock::Lex::MatchFirst.new.instance_eval(definition)
    end

    def parser(tokens, start:, &definition)
      grammar = Grammar.new(start)
      grammar.instance_eval(definition)

      Bullock::Parse::LALR1.new(grammar)
    end
  end
end
