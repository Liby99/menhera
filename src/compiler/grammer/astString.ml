open Printf
open Ast

let rec string_of_list (ls : 'a list) (string_of_a : 'a -> string) : string =
    let rec f ls =
        match ls with
            | [] -> ""
            | [a] -> string_of_a a
            | a :: rst -> (string_of_a a) ^ ", " ^ (f rst)
    in "[" ^ (f ls) ^ "]"

let rec string_of_type_sig (t : type_sig) : string =
    match t with
        | TypeSig(n, ts) ->
            sprintf "TypeSig(\"%s\", %s)" n (string_of_list ts string_of_type_sig)

let rec string_of_type_def_sig (t : type_def_sig) : string =
    match t with
        | TypeDefSig(n, gs) ->
            sprintf "TypeDefSig(\"%s\", %s)" n (string_of_list gs (fun x -> "\"" ^ x ^ "\""))

let rec string_of_ctor (c : ctor_def) : string =
    match c with
        | CtorDef(n, ts) ->
            sprintf "CtorDef(\"%s\", %s)" n (string_of_list ts string_of_type_sig)

let rec string_of_type_def (t : type_def) : string =
    match t with
        | TypeDef(tds, ctors) ->
            sprintf "TypeDef(%s, %s)" (string_of_type_def_sig tds) (string_of_list ctors string_of_ctor)

let rec string_of_import (i : import) : string =
    match i with
        | Import(n) -> sprintf "Import(\"%s\")" n

let rec string_of_section (s : section) : string =
    match s with
        | TypeSection(td) -> sprintf "TypeSection(%s)" (string_of_type_def td)
        | ImportSection(is) -> sprintf "ImportSection(%s)" (string_of_list is string_of_import)

let rec string_of_prog (t : prog) : string =
    match t with
        | Program(ss) -> sprintf "Program(%s)" (string_of_list ss string_of_section)
