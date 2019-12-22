open Error
open Parsing
open Internal
open Std
open Typing
open Eval

let () =
  let ast = parse "true && 1 == 2" in
  Printf.printf "%s\n" (Grammar.show_expr ast) ;
  let expr = internalize stdctx_typing ast in
  Printf.printf "%s\n" (Expression.show expr) ;
  let v = eval stdctx expr in
  Printf.printf "%s\n" (Value.show v) ;
  ()
