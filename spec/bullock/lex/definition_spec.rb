describe Bullock::Lex::Definition do
  it "gives an empty map of rules if rule is never called" do
    instance = Bullock::Lex::Definition.new

    expect(instance.rules).to be_empty
  end

  it "gives a single rule when rule is called only once" do
    instance = Bullock::Lex::Definition.new

    instance.rule(/regex/) {}

    expect(instance.rules.keys.length).to eq 1
  end

  it "stores a rule also when using instance_eval" do
    instance = Bullock::Lex::Definition.new

    instance.instance_eval do
      rule(/regex/) {}
    end

    expect(instance.rules.keys.length).to eq 1
  end

  it "accepts an action for a given rule" do
    instance = Bullock::Lex::Definition.new
    action = ->{}

    instance.rule(/regex/, &action)

    expect(instance.rules[/regex/][:action]).to be action
  end

  it "puts rule in the :base state if no state is specified" do
    instance = Bullock::Lex::Definition.new

    instance.rule(/regex/, :base) {}

    expect(instance.rules[/regex/][:state]).to be :base
  end

  it "accepts rule in a different state" do
    instance = Bullock::Lex::Definition.new

    instance.rule(/regex/, :another_state) {}

    expect(instance.rules[/regex/][:state]).to be :another_state
  end

  it "tolerates rule to be called without a block" do
    instance = Bullock::Lex::Definition.new

    instance.rule(/regex/)

    expect(instance.rules[/regex/][:action]).to be_nil
  end
end
