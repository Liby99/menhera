open Printf
open Ast

let rec string_of_prog (p : prog) : string =
    match p with
        | Program(e) -> sprintf "Program(%s)" (string_of_expr e)

and string_of_expr (e : expr) : string =
    match e with
        | EInt(i) -> sprintf "EInt(%d)" i
        | EBinOp(op, e1, e2) ->
            let ops = (string_of_binop op) in
            let e1s = (string_of_expr e1) in
            let e2s = (string_of_expr e2) in
            sprintf "EBinOp(%s, %s, %s)" ops e1s e2s

and string_of_binop (op : binop) : string =
    match op with
        | Plus -> "Plus"
        | Minus -> "Minus"
