open Parsing
open ParserTest
open Printf
open Array

let print_help () = printf "usage: menhera [--test] [--help]\n"

let main (argv : string array) : int =
    if Array.length argv > 1 then
        match argv.(1) with
            | "--test"
            | "-t" ->
                (test_parsing (); 0)
            | "--help"
            | "-h" ->
                (print_help (); 0)
            | _ -> failwith "Not implemented"
    else
        (print_help (); 0)
;;

main Sys.argv
