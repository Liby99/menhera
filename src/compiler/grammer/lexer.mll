{
    open Parser
    exception SyntaxError of string
}

let white = [' ' '\t']+

(* numbers related *)
let digit = ['0'-'9']
let frac = '.' digit*
let exp = ['e' 'E'] ['-' '+']? digit+
let float = digit* frac? exp?
let int = '-'? digit+

(* string related *)
let letter = ['a'-'z' 'A'-'Z']
let lud = ['a'-'z' 'A'-'Z' '_' '0'-'9']
let id = letter lud*

rule read = parse
    | white { read lexbuf }
    | "import" { IMPORT }
    | "as" { AS }
    | "type" { TYPE }
    | "main" { MAIN }
    | "(" { LPAREN }
    | ")" { RPAREN }
    | "{" { LBRACE }
    | "}" { RBRACE }
    | "<" { LANGLE }
    | ">" { RANGLE }
    | "=>" { ARROW }
    | "," { COMMA }
    | "?" { QUESTION }
    | ":" { COLON }
    | "let" { LET }
    | "in" { IN }
    | "if" { IF }
    | "then" { THEN }
    | "else" { ELSE }
    | "=" { ASSIGN }
    | "+" { PLUS }
    | "-" { MINUS }
    | "*" { STAR }
    | "/" { SLASH }
    | "&&" { AND }
    | "||" { OR }
    | "==" { EQUAL }
    | "!=" { INEQUAL }
    | ">=" { GTE }
    | "<=" { LTE }
    | "!" { EXCLAM }
    | "$" { DOLLAR }
    | "true" { BOOL true }
    | "false" { BOOL false }
    | '"' { read_string (Buffer.create 128) lexbuf }
    | id { ID (Lexing.lexeme lexbuf) }
    | int { INT (int_of_string (Lexing.lexeme lexbuf)) }
    | float { FLOAT (float_of_string (Lexing.lexeme lexbuf)) }
    | _ { raise (SyntaxError ("Unexpected character: " ^ Lexing.lexeme lexbuf)) }
    | eof { EOF }

and read_string buf = parse
    | '"'       { STRING (Buffer.contents buf) }
    | '\\' '/'  { Buffer.add_char buf '/'; read_string buf lexbuf }
    | '\\' '\\' { Buffer.add_char buf '\\'; read_string buf lexbuf }
    | '\\' 'b'  { Buffer.add_char buf '\b'; read_string buf lexbuf }
    | '\\' 'f'  { Buffer.add_char buf '\012'; read_string buf lexbuf }
    | '\\' 'n'  { Buffer.add_char buf '\n'; read_string buf lexbuf }
    | '\\' 'r'  { Buffer.add_char buf '\r'; read_string buf lexbuf }
    | '\\' 't'  { Buffer.add_char buf '\t'; read_string buf lexbuf }
    | [^ '"' '\\']+ { Buffer.add_string buf (Lexing.lexeme lexbuf); read_string buf lexbuf }
    | _ { raise (SyntaxError ("Illegal string character: " ^ Lexing.lexeme lexbuf)) }
    | eof { raise (SyntaxError ("String is not terminated")) }
