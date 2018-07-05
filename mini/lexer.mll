{
    open Lexing
    open Parser
    
    exception SyntaxError of string
    
    let next_line lexbuf =
        let pos = lexbuf.lex_curr_p in
        lexbuf.lex_curr_p <- {
            pos with
                pos_bol = lexbuf.lex_curr_pos;
                pos_lnum = pos.pos_lnum + 1
        }
}

let white = [' ' '\t']+

(* numbers related *)
let digit = ['0'-'9']
let frac = '.' digit*
let exp = ['e' 'E'] ['-' '+']? digit+
let float = digit* frac? exp?
let int = '-'? digit+
let wc = '_'

(* string related *)
let letter = ['a'-'z' 'A'-'Z']
let lud = ['a'-'z' 'A'-'Z' '_' '0'-'9']
let id = letter lud*

(* comment related *)
let any = _
let comment = "/*" any* "*/"

rule read = parse
    | white { read lexbuf }
    | '\n' { next_line lexbuf; read lexbuf }
    | "/*" { multiline_comment lexbuf; }
    | "//" { singleline_comment lexbuf; }
    | "(" { LPAREN }
    | ")" { RPAREN }
    | "+" { PLUS }
    | "-" { MINUS }
    | "let" { LET }
    | "in" { IN }
    | "=" { ASSIGN }
    | "true" { BOOL true }
    | "false" { BOOL false }
    | id { ID (Lexing.lexeme lexbuf) }
    | int { INT (int_of_string (Lexing.lexeme lexbuf)) }
    | _ { raise (SyntaxError ("Unexpected character: " ^ Lexing.lexeme lexbuf)) }
    | eof { EOF }

and multiline_comment = parse
    | "*/" { read lexbuf }
    | eof { failwith "unterminated comment" }
    | '\n' { next_line lexbuf; multiline_comment lexbuf }
    | _ { multiline_comment lexbuf }

and singleline_comment = parse
    | '\n' { next_line lexbuf; read lexbuf }
    | eof { read lexbuf }
    | _ { singleline_comment lexbuf }
