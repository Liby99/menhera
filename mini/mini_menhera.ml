(* System related *)
open Array
open Printf
open Filename

(* Parsing related *)
open Parsing
open AstString

(* Compile related *)
open Compile

let print_help () = printf "usage: menhera [--test] [--help] [--parse FILENAME]\n"

let get_filename (argv : string array) (index : int) : string =
    if Array.length argv > 2 then
        Filename.concat (Sys.getcwd ()) argv.(index)
    else failwith "Please specify file to parse"

let main (argv : string array) : int =
    if Array.length argv > 1 then
        match argv.(1) with
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
                (printf "%s\n" (Llvm.string_of_llvalue ll); 0)
            | _ -> failwith "Not implemented"
    else
        (print_help (); 0)
;;

main Sys.argv;;
