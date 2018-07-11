open Printf

open Ast

exception InvalidInput of string

let get_filename (argv : string array) (index : int) : string =
  if Array.length argv > 2 then
    Filename.concat (Sys.getcwd ()) argv.(index)
  else failwith "Please specify file to parse"

let main (argv : string array) : unit =
  if Array.length argv > 1 then
    let fst = argv.(1) in
    match fst with
      | "--help" | "-h" ->
        Help.print_help ();
      | "--parse" | "-p" ->
        let filename = get_filename argv 2 in
        let ast = Grammer.parse_file filename in
        printf "%s\n" (AstString.string_of_prog ast);
      | "--llvm" | "-l" ->
        let filename = get_filename argv 2 in
        let ast = Grammer.parse_file filename in
        let ll = Compiler.compile_prog ast in
        printf "%s\n" (Llvm.string_of_llmodule ll);
      | "--exec" | "-e" ->
        let filename = get_filename argv 2 in
        let ast = Grammer.parse_file filename in
        let ll = Compiler.compile_prog ast in
        let res = Runner.run ll "main" in
        printf "%d\n" res;
      | _ -> raise (InvalidInput(sprintf "%s not available" fst))
  else
    Help.print_help ();
;;

main Sys.argv;;
