require 'bullock/parse/definition'

describe Bullock::Parse::Definition do
  it "gives an empty map of rules if rule is never called" do
    instance = Bullock::Parse::Definition.new

    expect(instance.productions).to be_empty
  end

  it "stores a production when rule is called only once" do
    instance = Bullock::Parse::Definition.new

    instance.production(:a_symbol, 'expansion') {}

    expected_production = Bullock::Parse::Production.new(:a_symbol, 'expansion') {}
    expect(instance.productions).to eq [expected_production]
  end

  it "stores a production when using symbol" do
    instance = Bullock::Parse::Definition.new

    instance.symbol(:a_symbol) do
      produces('expansion') {}
    end

    expected_production = Bullock::Parse::Production.new(:a_symbol, 'expansion') {}
    expect(instance.productions).to eq [expected_production]
  end
end
