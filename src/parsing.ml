let parse s = Lexing.from_string s |> Parser.entry Lexer.read
