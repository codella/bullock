require 'bullock'

describe Bullock do
  it "instantiates a lexer" do
    lexer = Bullock.lexer do
      rule(/a/) { :A }
      rule(/b/) { :B }

      rule(/\s/)
    end
  end

  # it "instantiates a parser" do
  #   parser = Bullock.parser(start: :first) do
  #     production(:a, 'b c d') { ... }
  #     production(:b, 'X') { ... }
  #     production(:c, 'Y') { ... }
  #     symbol(:d) do
  #       produces('Z') { ... }
  #       produces(nil)
  #     end
  #   end
  # end
end
