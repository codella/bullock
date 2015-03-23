# __________      .__  .__                 __
# \______   \__ __|  | |  |   ____   ____ |  | __
#  |    |  _/  |  \  | |  |  /  _ \_/ ___\|  |/ /
#  |    |   \  |  /  |_|  |_(  <_> )  \___|    <
#  |______  /____/|____/____/\____/ \___  >__|_ \
#         \/                            \/     \/

module Bullock
  class << self
    def lexer(&definition)
      rules_collector = Bullock::Lex::RulesCollector.new
      rules_collector.instance_exec(&definition)

      Bullock::Lex::MatchFirst.new(rules_collector.rules)
    end

    def parser(&definition)
      grammar = Bullock::Parse::Grammar.new
      grammar.instance_exec(&definition)

      Bullock::Parse::LALR1.new(grammar)
    end
  end
end

require 'bullock/lex/rules_collector'
require 'bullock/lex/match_first'

require 'bullock/parse/grammar'
require 'bullock/parse/lalr1'
