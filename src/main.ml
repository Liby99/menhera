open Internal
open Error
open Std
open Typing
open Eval

let parse s = Lexing.from_string s |> Parser.entry Lexer.read

let main _ =
  let ast = parse "1 + 2" in
  Printf.printf "%s\n" (Grammar.show_expr ast) ;
  let expr = internalize stdctx_typing ast in
  Printf.printf "%s\n" (Expression.show expr) ;
  let v = eval stdctx expr in
  Printf.printf "%s\n" (Value.show v) ;
  ()

;;
main ()
