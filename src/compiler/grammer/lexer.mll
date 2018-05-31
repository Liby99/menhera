{
    open Parser
    exception SyntaxError of string
}

let white = [' ' '\t']+
let digit = ['0'-'9']
let int = '-'? digit+
let letter = ['a'-'z' 'A'-'Z']
let lud = ['a'-'z' 'A'-'Z' '_' '0'-'9']
let id = letter lud+?

rule read = parse
    | white { read lexbuf }
    | "type" { TYPE }
    | "import" { IMPORT }
    | "as" { AS }
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
    | _ { raise (SyntaxError ("Unexpected character: " ^ Lexing.lexeme lexbuf)) }
    | eof { EOF }
