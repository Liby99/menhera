{ open Parser }

let white = [' ' '\t']+
let digit = ['0'-'9']
let int = '-'? digit+
let letter = ['a'-'z' 'A'-'Z' '_']
let id = letter+

rule read =
    parse
    | white { read lexbuf }
    | "+" { PLUS }
    | "-" { MINUS }
    | "*" { TIMES }
    | "(" { LPAREN }
    | ")" { RPAREN }
    | "," { COMMA }
    | "=>" { ARROW }
    | "let" { LET }
    | "=" { ASSIGN }
    | "in" { IN }
    | "if" { IF }
    | "then" { THEN }
    | "else" { ELSE }
    | "true" { BOOL (true) }
    | "false" { BOOL (false) }
    | id { ID (Lexing.lexeme lexbuf) }
    | int { INT (int_of_string (Lexing.lexeme lexbuf)) }
    | eof { EOF }
