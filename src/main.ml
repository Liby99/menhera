open Ast
open Printf

let parse s =
    let lexbuf = Lexing.from_string s in
    let ast = Parser.prog Lexer.read lexbuf in
    ast
;;

Printf.printf "%s\n" (Ast.to_string (parse "let i = 3 in i + 4"));;
Printf.printf "%s\n" (Ast.to_string (parse "i + 4 + 6"));;
Printf.printf "%s\n" (Ast.to_string (parse "7 + 1 * 4"));;
Printf.printf "%s\n" (Ast.to_string (parse "if true then 1 + 3 else false"));;
Printf.printf "%s\n" (Ast.to_string (parse "let i = 2 in if i then true else false"));;
Printf.printf "%s\n" (Ast.to_string (parse "let i = 2 in let j = 3 in i + j"));;
Printf.printf "%s\n" (Ast.to_string (parse "let f = (a, b) => if a + b then a else b in f(3, 4)"));;
Printf.printf "%s\n" (Ast.to_string (parse "((a, b) => a + b)(3, 4)"));;
Printf.printf "%s\n" (Ast.to_string (parse "((a, b) => if a > b then a else b)(3, 4 + 6)"));;
