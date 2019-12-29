let input_file = ref ""

let show_ast = ref false

let show_intern = ref false

let show_result = ref false

let options =
  ref
    [ ("-show-ast", Arg.Set show_ast, "Show Abstract Syntax Tree")
    ; ("-show-intern", Arg.Set show_intern, "Show Internal Expression")
    ; ("-show-result", Arg.Set show_result, "Show Final Result") ]

let parse_arg arg = input_file := arg

let usage = "menhera [OPTIONS] [FILE]"

let read_file filename =
  let ch = open_in filename in
  let s = really_input_string ch (in_channel_length ch) in
  close_in ch ; s

let () =
  Arg.parse_dynamic options parse_arg usage ;
  if !input_file = "" then Printf.printf "Please specify file\n" ;
  let content = read_file !input_file in
  let ast = Parsing.parse content in
  if !show_ast then Printf.printf "%s\n" (Grammar.show_expr ast) ;
  let expr = Typing.internalize Std.stdctx_typing ast in
  if !show_intern then Printf.printf "%s\n" (Internal.Expression.show expr) ;
  let v = Eval.eval Std.stdctx expr in
  if !show_result then Printf.printf "%s\n" (Eval.Value.show v) ;
  ()
