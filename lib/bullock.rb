# __________      .__  .__                 __
# \______   \__ __|  | |  |   ____   ____ |  | __
#  |    |  _/  |  \  | |  |  /  _ \_/ ___\|  |/ /
#  |    |   \  |  /  |_|  |_(  <_> )  \___|    <
#  |______  /____/|____/____/\____/ \___  >__|_ \
#         \/                            \/     \/

module Bullock
  class << self
    def lexer(&block)
      definition = ::Bullock::Lex::Definition.new
      definition.instance_exec(&block)

      ::Bullock::Lex::MatchFirst.new(definition.rules)
    end

    def parser(start:, &block)
      definition = ::Bullock::Parse::Definition.new
      definition.instance_exec(&block)

      grammar = ::Bullock::Parse::Grammar.new(start, definition.productions)
      ::Bullock::Parse::LALR1.new(grammar)
    end
  end
end

require 'forwardable'
require 'set'

require 'bullock/error'

require 'bullock/lex/definition'
require 'bullock/lex/environment'
require 'bullock/lex/error'
require 'bullock/lex/match_first'
require 'bullock/lex/token'

require 'bullock/parse/definition'
require 'bullock/parse/dfa'
require 'bullock/parse/error'
require 'bullock/parse/extended_grammar'
require 'bullock/parse/extended_production'
require 'bullock/parse/extended_symbol'
require 'bullock/parse/first_set'
require 'bullock/parse/follow_set'
require 'bullock/parse/goto_table'
require 'bullock/parse/grammar'
require 'bullock/parse/item_set'
require 'bullock/parse/item_sets_dfa'
require 'bullock/parse/lalr1'
require 'bullock/parse/production'
require 'bullock/parse/symbol'
require 'bullock/parse/symbol_expansions'
require 'bullock/parse/track'
