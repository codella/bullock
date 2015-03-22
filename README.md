<img src="logo.png" height='64'>

# Bullock
A simple Ruby PEG implementation - no strings attached!

## Approaching Lexing and Parsing

```ruby
lexer = Bullock.lexer do
  rule(/regex/, :state) { |match| ... }
  rule(/another_regex/) { ... }
end

tokens = lexer.lex(string)
```

```ruby
parser = Bullock.parser do
  symbol(:a) do
    produces('a b .c') { |c| ... }
    produces('x y z') { |x, y, z| ... }
  end

  production(:b, 'x .Y? z') { |y| ... }
end

outcome = parser.parse(tokens)
```
