module Bullock
  module Parse
    class FollowSet
      def process(first_set, grammar)
        follow_set = {}

        follow_set[grammar.start] = [::Bullock::Lex::Token::EOS]

        follow_set
      end
    end
  end
end
