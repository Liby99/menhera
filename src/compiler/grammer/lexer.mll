{
    open Parser
    exception SyntaxError of string
}

let white = [' ' '\t']+
let digit = ['0'-'9']
let int = '-'? digit+
let letter = ['a'-'z' 'A'-'Z' '_']
let id = letter+

rule read = parse
    | white { read lexbuf }
    | "type" { TYPE }
    | "(" { LPAREN }
    | ")" { RPAREN }
    | "[" { LBRACKET }
    | "]" { RBRACKET }
    | "<" { LANGLE }
    | ">" { RANGLE }
    | "{" { LBRACE }
    | "}" { RBRACE }
    | "," { COMMA }
    | id { ID (Lexing.lexeme lexbuf) }
    | _ { raise (SyntaxError ("Unexpected char: " ^ Lexing.lexeme lexbuf)) }
    | eof { EOF }
