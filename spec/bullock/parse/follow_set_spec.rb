require 'bullock/parse/follow_set'
require 'bullock/parse/extended_symbol'
require 'bullock/parse/symbol'
require 'bullock/lex/token'

describe Bullock::Parse::FollowSet do
  let(:_a) { Bullock::Parse::Symbol.new(:a, false, false) }
  let(:x_a) { Bullock::Parse::ExtendedSymbol.new(0, _a, 1) }

  it "puts EOS in the follow set of the start symbol" do
    first_set = {}
    grammar = double(:extended_grammar)
    allow(grammar).to receive(:start) { x_a }

    expect(Bullock::Parse::FollowSet.new.process(first_set, grammar)).to eq ({
      x_a => [::Bullock::Lex::Token::EOS]
    })
  end
end
