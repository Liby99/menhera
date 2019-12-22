open Error
open Parsing
open Internal
open Std
open Typing
open Eval

let main _ =
  let ast = parse "if 4 == 1 + 3 then 5 else 7" in
  Printf.printf "%s\n" (Grammar.show_expr ast) ;
  let expr = internalize stdctx_typing ast in
  Printf.printf "%s\n" (Expression.show expr) ;
  let v = eval stdctx expr in
  Printf.printf "%s\n" (Value.show v) ;
  ()

;;
main ()
