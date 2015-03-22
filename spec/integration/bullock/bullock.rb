# This is a playground to test what a possible api for Bullock can be.

# lexer = Bullock.lexer do
#   rule(/regex/, :state) { |match| ... }
#   rule(/another_regex/) { |match| ... }
# end
#
# tokens = lexer.lex(string)
#
# parser = Bullock.parser do
#   symbol(:a) do
#     expands('a b .c') { |c| ... }
#     expands('x y z') { |x, y, z| ... }
#   end
#
#   production(:b, 'x .Y z') { |y| ... }
# end
#
# outcome = parser.parse(tokens)
