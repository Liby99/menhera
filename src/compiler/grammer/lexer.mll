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
    | "import" { IMPORT }
    | "as" { AS }
    | "type" { TYPE }
    | "main" { MAIN }
    | "(" { LPAREN }
    | ")" { RPAREN }
    | "[" { LBRACKET }
    | "]" { RBRACKET }
    | "<" { LANGLE }
    | ">" { RANGLE }
    | "{" { LBRACE }
    | "}" { RBRACE }
    | "," { COMMA }
    | "+" { PLUS }
    | id { ID (Lexing.lexeme lexbuf) }
    | int { INT (int_of_string (Lexing.lexeme lexbuf)) }
    | _ { raise (SyntaxError ("Unexpected character: " ^ Lexing.lexeme lexbuf)) }
    | eof { EOF }
