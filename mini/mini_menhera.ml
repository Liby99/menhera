(* System related *)
open Array
open Printf
open Filename

(* Parsing related *)
open Parsing
open AstString

(* Compile related *)
open Compile
(* open Runner *)

let print_help () = printf "usage: mini_menhera [--help|-h] [--parse|-p FILENAME] [--llvm|-l FILENAME]\n"

let get_filename (argv : string array) (index : int) : string =
    if Array.length argv > 2 then
        Filename.concat (Sys.getcwd ()) argv.(index)
    else failwith "Please specify file to parse"

let main (argv : string array) : int =
    if Array.length argv > 1 then
        let fst = argv.(1) in
        match fst with
            | "--help" | "-h" ->
                (print_help (); 0)
            | "--parse" | "-p" ->
                let filename = get_filename argv 2 in
                let ast = Parsing.parse_file filename in
                (printf "%s\n" (AstString.string_of_prog ast); 0)
            | "--llvm" | "-l" ->
                let filename = get_filename argv 2 in
                let ast = Parsing.parse_file filename in
                let ll = Compile.compile_prog ast in
                (printf "%s\n" (Llvm.string_of_llmodule ll); 0)
            | "--exec" | "-e" ->
                let filename = get_filename argv 2 in
                let ast = Parsing.parse_file filename in
                let ll = Compile.compile_prog ast in
                let res = Runner.run ll "main" in
                (printf "%d\n" res; 0)
            | _ -> failwith (sprintf "%s not available" fst)
    else
        (print_help (); 0)
;;

main Sys.argv;;
