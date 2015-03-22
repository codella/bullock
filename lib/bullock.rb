require 'bullock/lex/lexer'
require 'bullock/parse/lalr1'

class Bullock
  class << self
    def lex(string, &definition)
      Bullock::Lex::Lexer.new(definition)
    end

    def parse(*)
      lalr1(*)
    end

    def lalr1(tokens, start: :start, &definition)
      parser = Bullock::Parse::LALR1.new(start, definition)
      parser.parse(tokens)
    end
  end
end
