lexer = Bullock.lexer do
  rule(/\+/) { :ADD }
  rule(/\-/) { :SUB }
  rule(/\*/) { :MUL }
  rule(/\\/) { :DIV }
  rule(/\d+/) { |match| [:INT, match[0].to_i] }

  rule(/\s/)
end

parser = Bullock.parser(start: :expression) do
  symbol(:expression) do
    produces('ADD expression expression') { |_, e1, e2| e1 + e2 }
    produces('SUB expression expression') { |_, e1, e2| e1 - e2 }
    produces('MUL expression expression') { |_, e1, e2| e1 * e2 }
    produces('DIV expression expression') { |_, e1, e2| e1 / e2 }
    produces('INT') { |int| int.value }
  end
end

tokens = lexer.lex('+ 1 1')
parser.parse(tokens) == 2
