# __________      .__  .__                 __
# \______   \__ __|  | |  |   ____   ____ |  | __
#  |    |  _/  |  \  | |  |  /  _ \_/ ___\|  |/ /
#  |    |   \  |  /  |_|  |_(  <_> )  \___|    <
#  |______  /____/|____/____/\____/ \___  >__|_ \
#         \/                            \/     \/

module Bullock
  class << self
    def lexer(&block)
      definition = Bullock::Lex::Definition.new
      definition.instance_exec(&block)

      Bullock::Lex::MatchFirst.new(definition.rules)
    end

    def parser(start:, &block)
      definition = Bullock::Parse::Definition.new
      definition.instance_exec(&block)

      grammar = Bullock::Parse::Grammar.new(start, definition.productions)
      Bullock::Parse::LALR1.new(grammar)
    end
  end
end

require 'bullock/lex/definition'
require 'bullock/lex/match_first'

require 'bullock/parse/definition'
require 'bullock/parse/lalr1'
