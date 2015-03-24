require 'bullock/lex/match_first'

describe Bullock::Lex::MatchFirst do
  describe "matching criteria" do
    it "executes the action of the first matching rule" do
      rules = {
        /x/ => {
          state: :base,
          action: Proc.new { :SMALLER_MATCH }
        },
        /xx/ => {
          state: :base,
          action: Proc.new { :LONGER_MATCH }
        }
      }

      lexer = Bullock::Lex::MatchFirst.new(rules)
      expect(lexer.lex('xx').map(&:token)).to eq [:SMALLER_MATCH, :SMALLER_MATCH, :EOS]
    end

    it "skips rules not in the current state" do
      rules = {
        /x/ => {
          state: :a_state,
          action: Proc.new { :SMALLER_MATCH }
        },
        /xx/ => {
          state: :base,
          action: Proc.new { :LONGER_MATCH }
        }
      }

      lexer = Bullock::Lex::MatchFirst.new(rules)
      expect(lexer.lex('xx').map(&:token)).to eq [:LONGER_MATCH, :EOS]
    end
  end

  describe "puts EOS token at the end of the stream" do
    it "when string is empty" do
      rules = {
        /x/ => {
          state: :base,
          action: nil
        }
      }

      lexer = Bullock::Lex::MatchFirst.new(rules)
      expect(lexer.lex('').last.token).to eq :EOS
    end

    it "when string is not empty" do
      rules = {
        /./ => {
          state: :base,
          action: nil
        }
      }

      lexer = Bullock::Lex::MatchFirst.new(rules)
      expect(lexer.lex('....').last.token).to eq :EOS
    end
  end

  describe "positioning" do
    describe "line number" do
      it "when there is only one line" do
        rules = {
          /x/ => {
            state: :base,
            action: Proc.new { :X }
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
            action: Proc.new { :X }
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
            action: Proc.new { :X }
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
            action: Proc.new { :X }
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
      it "when matching a 1 character token" do
        rules = {
          /x+/ => {
            state: :base,
            action: Proc.new { :X }
          }
        }

        lexer = Bullock::Lex::MatchFirst.new(rules)
        expect(lexer.lex('x').first.length).to eq 1
      end

      it "when matching a 2 character token" do
        rules = {
          /x+/ => {
            state: :base,
            action: Proc.new { :X }
          }
        }

        lexer = Bullock::Lex::MatchFirst.new(rules)
        expect(lexer.lex('xx').first.length).to eq 2
      end
    end

    describe "offset" do
      it "when matching the beginning of the string" do
        rules = {
          /x/ => {
            state: :base,
            action: Proc.new { :X }
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
            action: Proc.new { :X }
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
            action: Proc.new { :X }
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
