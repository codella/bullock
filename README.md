<img src="logo.png" height='64'>

# Bullock
A simple Ruby PEG implementation - no strings attached!

## Why Would I Need Another Ruby PEG?
Probably you don't, but I definitely do and I would like to explain you why.

I have been tackling some interesting tasks recently, such as rewriting a TemplateHandler for Rails that speaks Handlebars.

At first, I started my investigation to understand what is the best PEG for me and my team. We were in need of a PEG that was both less intrusive and with a smooth learning curve. Also, we needed the parser and lexer code to be easily maintainable in the future.

We ended up choosing [RLTK](https://github.com/chriswailes/RLTK), that in my opinion is a good example of clear API in terms of lexing and parsing specification - so we decided to adopt it. Although we found it compelling an clean at first, we ended up in merging in our runtime other gems that are an unnecessary risk for us. This happened simply because this implementation, like many other out there, they do **more than we actually needed**.

This gem aims to give to the Ruby world a simple PEG implementation, with a smooth learning curve, simple API, excellent test coverage, examples of usage with great explanation and, last but not least, **no runtime dependencies at all**.

These are the actual gems that are needed in develoment mode:
```
Using columnize 0.9.0
Using debugger-linecache 1.2.0
Using slop 3.6.0
Using byebug 4.0.3
Using diff-lcs 1.2.5
Using rspec-support 3.2.1
Using rspec-core 3.2.0
Using rspec-expectations 3.2.0
Using rspec-mocks 3.2.0
Using rspec 3.2.0
Using bundler 1.8.2
```

**11 gems needed in development mode, and 0 gems needed at runtime!**

## Why This Logo?
Well... There was a Yacc, then a Bison followed and now... a Bullock :^)

## How to Bullock

### Lexing
```ruby
lexer = Bullock.lexer do
  rule(/regex/, :state) { |match| ... }
  rule(/another_regex/) { ... }
end

tokens = lexer.lex(string)
```

#### Match First Lexer

#### Match Longest Lexer

### Parsing
```ruby
parser = Bullock.parser(start: :a) do
  symbol(:a) do
    produces('a b .c') { |c| ... }
    produces('x y z') { |x, y, z| ... }
  end

  production(:b, 'x .Y z') { |y| ... }
end

outcome = parser.parse(tokens)
```

## Error Handling

### Lexer Errors

### Parse Errors

## How to Contribute

### Principles

### Practices

## Examples

### Calculator

### External DSL

## References

 * http://web.cs.dal.ca/~sjackson/lalr1.html
 * https://www.cs.uaf.edu/~cs331/notes/FirstFollow.pdf
