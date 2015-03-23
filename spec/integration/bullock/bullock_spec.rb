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
  #   lexer = Bullock.parser do
  #     start_from :first
  #
  #     production(:a, 'b c d') {}
  #     production(:first, 'a') {}
  #   end
  # end
end
