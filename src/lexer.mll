{ open Parser
  exception SyntaxError of string }

let white = [' ' '\t' '\n']+
let digit = ['0'-'9']
let int = '-'? digit+
let letter = ['a'-'z' 'A'-'Z']
let lud = ['a'-'z' 'A'-'Z' '_' '0'-'9']
let id = letter lud+?

rule read = parse
  | white { read lexbuf }
  | "(" { LPAREN }
  | ")" { RPAREN }
  (* | "{" { LBRACE } *)
  (* | "}" { RBRACE } *)
  (* | "<" { LANGLE } *)
  (* | ">" { RANGLE } *)
  | "=>" { ARROW }
  | "," { COMMA }
  | "let" { LET }
  | ":" { COLON }
  | "=" { EQUAL }
  | "in" { IN }
  | "if" { IF }
  | "then" { THEN }
  | "else" { ELSE }
  | "true" { TRUE }
  | "false" { FALSE }
  | "+" { PLUS }
  | "-" { MINUS }
  | "*" { STAR }
  | "/" { SLASH }
  | "==" { DOUBLE_EQUAL }
  | "&&" { DOUBLE_AMP }
  | "||" { DOUBLE_VERT }
  | id { ID (Lexing.lexeme lexbuf) }
  | int { INT (int_of_string (Lexing.lexeme lexbuf)) }
  | _ { raise (SyntaxError ("Unexpected character: " ^ Lexing.lexeme lexbuf)) }
  | eof { EOF }