require 'bullock/lex/match_first'

describe Bullock::Lex::MatchFirst do
  describe "matching criteria" do
    it "executes the action of the first matching rule" do
      rules = {
        /x/ => {
          state: :base,
          action: ->(match){ :SMALLER_MATCH }
        },
        /xx/ => {
          state: :base,
          action: ->(match){ :LONGER_MATCH }
        }
      }

      lexer = Bullock::Lex::MatchFirst.new(rules)
      expect(lexer.lex('xx').map(&:token)).to eq [:SMALLER_MATCH, :SMALLER_MATCH, :EOS]
    end

    it "skips rules not in the current state" do
      rules = {
        /x/ => {
          state: :a_state,
          action: ->(match){ :SMALLER_MATCH }
        },
        /xx/ => {
          state: :base,
          action: ->(match){ :LONGER_MATCH }
        }
      }

      lexer = Bullock::Lex::MatchFirst.new(rules)
      expect(lexer.lex('xx').map(&:token)).to eq [:LONGER_MATCH, :EOS]
    end
  end

  describe "positioning" do
    describe "line number" do
      it "when there is only one line" do
        rules = {
          /x/ => {
            state: :base,
            action: ->(match){ :X }
          },
          /./ => {
            state: :base,
            action: nil
          }
        }

        lexer = Bullock::Lex::MatchFirst.new(rules)
        expect(lexer.lex('....x')[-2].line).to eq 1
      end

      it "when there are more lines" do
        rules = {
          /x/ => {
            state: :base,
            action: ->(match){ :X }
          },
          /./m => {
            state: :base,
            action: nil
          }
        }

        lexer = Bullock::Lex::MatchFirst.new(rules)
        expect(lexer.lex("..\n..x")[-2].line).to eq 2
      end
    end

    describe "column number" do
      it "when there is only one line" do
        rules = {
          /x/ => {
            state: :base,
            action: ->(match){ :X }
          },
          /./ => {
            state: :base,
            action: nil
          }
        }

        lexer = Bullock::Lex::MatchFirst.new(rules)
        expect(lexer.lex('....x')[-2].column).to eq 5
      end

      it "when there are more lines" do
        rules = {
          /x/ => {
            state: :base,
            action: ->(match){ :X }
          },
          /./m => {
            state: :base,
            action: nil
          }
        }

        lexer = Bullock::Lex::MatchFirst.new(rules)
        expect(lexer.lex("..\n..x")[-2].column).to eq 3
      end
    end

    describe "length" do
    end

    describe "offset" do
      it "when matching the beginning of the string" do
        rules = {
          /x/ => {
            state: :base,
            action: ->(match){ :X }
          },
          /./ => {
            state: :base,
            action: nil
          }
        }

        lexer = Bullock::Lex::MatchFirst.new(rules)
        expect(lexer.lex('x....').first.offset).to eq 0
      end

      it "when matching the end of the string" do
        rules = {
          /x/ => {
            state: :base,
            action: ->(match){ :X }
          },
          /./ => {
            state: :base,
            action: nil
          }
        }

        lexer = Bullock::Lex::MatchFirst.new(rules)
        expect(lexer.lex('....x')[-2].offset).to eq 4
      end

      it "when string has new lines" do
        rules = {
          /x/ => {
            state: :base,
            action: ->(match){ :X }
          },
          /./m => {
            state: :base,
            action: nil
          }
        }

        lexer = Bullock::Lex::MatchFirst.new(rules)
        expect(lexer.lex(".\n.\n.\n.x")[-2].offset).to eq 7
      end
    end
  end

  it "throws when nil is passed as rule set" do
    expect do
      Bullock::Lex::MatchFirst.new(nil)
    end.to raise_error
  end

  it "throws when empty Hash is passed as rule set" do
    expect do
      Bullock::Lex::MatchFirst.new({})
    end.to raise_error
  end
end
