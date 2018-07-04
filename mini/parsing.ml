open Lexing
open Lexer
open Parser
open Ast
open Printf

exception ParseError of string

let error_position (lexbuf : lexbuf) =
    let pos = lexbuf.lex_curr_p in
    sprintf "line %d, character %d" pos.pos_lnum (pos.pos_cnum - pos.pos_bol + 1)

let parse_buf (lexbuf : lexbuf) : prog =
    try
        Parser.prog Lexer.read lexbuf
    with
        | SyntaxError(s) -> raise (ParseError (sprintf "Syntax Error at %s: %s" (error_position lexbuf) s))
        | Parser.Error -> raise (ParseError (sprintf "Parser Error at %s" (error_position lexbuf)))
        | _ -> raise (ParseError "Unknown Error")

let parse_string (input : string) : prog =
    let lexbuf = Lexing.from_string input in
    let ast = parse_buf lexbuf in
    ast

let parse_file (filename : string) : prog =
    let ic = open_in filename in
    let lexbuf = Lexing.from_channel ic in
    let ast = parse_buf lexbuf in
    ast
