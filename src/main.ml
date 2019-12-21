open Internal
open Error
open Std
open Eval

let parse s = Lexing.from_string s |> Parser.entry Lexer.read

let main _ =
  let ast = parse "1 + 2" in
  Printf.printf "%s\n" (Grammar.show_expr ast) ;
  ()

;;
main ()
