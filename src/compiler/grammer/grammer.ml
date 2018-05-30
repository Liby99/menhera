open Ast

let parse p s =
    let lexbuf = Lexing.from_string s in
    let ast = p Lexer.read lexbuf in
    ast

let parse_type_def = parse Parser.type_def
