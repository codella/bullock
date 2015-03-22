<img src="logo.png" height='64'>
# Bullock
A simple Ruby PEG implementation - no strings attached!

# A Quick Example of Usage

```ruby
lexer = Bullock.lexer do
  rule(/regex/, :state) { |match| ... }
  rule(/another_regex/) { |match| ... }
end
```

```ruby
tokens = lexer.lex(string)

parser = Bullock.parser do
  symbol(:a) do
    expands('a b .c') { |c| ... }
    expands('x y z') { |x, y, z| ... }
  end

  production(:b, 'x .Y z') { |y| ... }
end

outcome = parser.parse(tokens)
```
