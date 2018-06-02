(* System related *)
open Array
open Printf
open Filename

(* Parsing related *)
open Parsing
open AstString
open ParserTest

let print_help () = printf "usage: menhera [--test] [--help] [--parse FILENAME]\n"

let main (argv : string array) : int =
    if Array.length argv > 1 then
        match argv.(1) with
            | "--test"
            | "-t" ->
                (test_parsing (); 0)
            | "--help"
            | "-h" ->
                (print_help (); 0)
            | "--parse"
            | "-p" ->
                if Array.length argv > 2 then
                    let filename = Filename.concat (Sys.getcwd ()) argv.(2) in
                    printf "Parsing File: %s\n" filename;
                    let ast = Parsing.parse_file filename in
                    printf "%s\n" (AstString.string_of_prog ast);
                    0
                else failwith "Please specify file to parse"
            | _ -> failwith "Not implemented"
    else
        (print_help (); 0)
;;

main Sys.argv;;
