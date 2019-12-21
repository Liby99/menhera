open Internal
open Error
open Std
open Eval

let parse s =
  let lexbuf = Lexing.from_string s in
  let ast = Parser.expr Lexer.read lexbuf in
  ast

let main _ =
  Printf.printf "Hello, menhera" ;
  ()

;;

main ()