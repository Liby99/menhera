open Printf
open Ast

let rec string_of_list (ls : 'a list) (string_of_a : 'a -> string) : string =
    let rec f ls =
        match ls with
            | [] -> ""
            | [a] -> string_of_a a
            | a :: rst -> (string_of_a a) ^ ", " ^ (f rst)
    in "[" ^ (f ls) ^ "]"

let rec string_of_type_def_sig (t : type_def_sig) : string =
    match t with
        | UnitTypeDefSig(n) -> sprintf "UnitTypeDefSig(\"%s\")" n
        | GenTypeDefSig(n, gs) -> sprintf "GenTypeDefSig(\"%s\", %s)" n (string_of_list gs (fun x -> "\"" ^ x ^ "\""))

let rec string_of_type_sig (t : type_sig) : string =
    match t with
        | UnitTypeSig(n) -> sprintf "UnitTypeSig(\"%s\")" n
        | GenTypeSig(n, ts) -> sprintf "GenTypeSig(\"%s\", %s)" n (string_of_list ts string_of_type_sig)
        | FuncTypeSig(ats, r) -> sprintf "FuncTypeSig(%s, %s)" (string_of_list ats string_of_type_sig) (string_of_type_sig r)

let rec string_of_ctor (c : ctor_def) : string =
    match c with
        | UnitCtor(n) -> sprintf "UnitCtor(\"%s\")" n
        | CompCtor(n, ts) -> sprintf "CompCtor(\"%s\", %s)" n (string_of_list ts string_of_type_sig)

let rec string_of_type_def (t : type_def) : string =
    match t with
        | TypeDef(tds, ctors) -> sprintf "TypeDef(%s, %s)" (string_of_type_def_sig tds) (string_of_list ctors string_of_ctor)

let rec string_of_import (i : import) : string =
    match i with
        | Import(n) -> sprintf "Import(\"%s\")" n
        | ImportAs(m, n) -> sprintf "ImportAs(\"%s\", \"%s\")" m n

let rec string_of_expr (e : expr) : string =
    match e with
        | Int(i) -> sprintf "Int(%d)" i
        | BinOp(op, e1, e2) ->
            let ops = match op with
                | Plus -> "Plus"
            in sprintf "BinOp(%s, %s, %s)" ops (string_of_expr e1) (string_of_expr e2)

let rec string_of_section (s : section) : string =
    match s with
        | TypeSect(td) -> sprintf "TypeSect(%s)" (string_of_type_def td)
        | ImportSect(is) -> sprintf "ImportSect(%s)" (string_of_list is string_of_import)
        | MainSect(e) -> sprintf "MainSect(%s)" (string_of_expr e)

let rec string_of_prog (t : prog) : string =
    match t with
        | Program(ss) -> sprintf "Program(%s)" (string_of_list ss string_of_section)
