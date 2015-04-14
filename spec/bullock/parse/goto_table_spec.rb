describe Bullock::Parse::GotoTable do
  let(:terminal) { Bullock::Parse::Symbol.new(:TERMINAL, false, true) }
  let(:non_terminal) { Bullock::Parse::Symbol.new(:stop, false, false) }

  it "includes non-terminal translations" do
    translation_table = {
      [0, terminal] => 1,
      [1, non_terminal] => 2
    }
    goto_table = Bullock::Parse::GotoTable.new(translation_table)

    expect(goto_table.goto([1, non_terminal])).to be 2
  end

  it "excludes terminal translations" do
    translation_table = {
      [0, terminal] => 1,
      [1, non_terminal] => 2
    }
    goto_table = Bullock::Parse::GotoTable.new(translation_table)

    expect do
      goto_table.goto([0, terminal])
    end.to raise_error(KeyError)
  end
end
