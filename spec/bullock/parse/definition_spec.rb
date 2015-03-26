require 'bullock/parse/definition'

describe Bullock::Parse::Definition do
  it "gives an empty map of rules if rule is never called" do
    instance = Bullock::Parse::Definition.new

    expect(instance.productions).to be_empty
  end

  it "gives a single production when rule is called only once" do
    instance = Bullock::Parse::Definition.new

    instance.production(:a_symbol, 'expansion') {}

    expect(instance.productions.length).to eq 1
  end

  it "stores a production also when using instance_eval" do
    instance = Bullock::Parse::Definition.new

    instance.instance_eval do
      production(:a_symbol, 'expansion') {}
    end

    expect(instance.productions.length).to eq 1
  end

  # it "accepts an action for a given rule" do
  #   instance = Bullock::Parse::Definition.new
  #   action = ->{}
  #
  #   instance.rule(/regex/, &action)
  #
  #   expect(instance.rules[/regex/][:action]).to be action
  # end
  #
  # it "puts rule in the :base state if no state is specified" do
  #   instance = Bullock::Parse::Definition.new
  #
  #   instance.rule(/regex/, :base) {}
  #
  #   expect(instance.rules[/regex/][:state]).to be :base
  # end
  #
  # it "accepts rule in a different state" do
  #   instance = Bullock::Parse::Definition.new
  #
  #   instance.rule(/regex/, :another_state) {}
  #
  #   expect(instance.rules[/regex/][:state]).to be :another_state
  # end
  #
  # it "tolerates rule to be called without a block" do
  #   instance = Bullock::Parse::Definition.new
  #
  #   instance.rule(/regex/)
  #
  #   expect(instance.rules[/regex/][:action]).to be_nil
  # end
end
