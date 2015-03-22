# This is a playground to test what a possible api for LALR1 can be.

parser = Bullock::Parse::LALR1.new(start: :root) do
  symbol(:a) do
    expands('a b .c') { |c| }
  end
end
