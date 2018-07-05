open Printf
open Ast

let rec string_of_prog (p : prog) : string =
    match p with
        | Program(e) -> sprintf "Program(%s)" (string_of_expr e)

and string_of_expr (e : expr) : string =
    match e with
        | EId(n) -> sprintf "EId(%s)" n
        | EInt(i) -> sprintf "EInt(%d)" i
        | EBool(b) -> sprintf "EBool(%s)" (if b then "true" else "false")
        | EBinOp(op, e1, e2) ->
            let ops = (string_of_binop op) in
            let e1s = (string_of_expr e1) in
            let e2s = (string_of_expr e2) in
            sprintf "EBinOp(%s, %s, %s)" ops e1s e2s
        | ELet(n, e, b) ->
            let es = (string_of_expr e) in
            let bs = (string_of_expr b) in
            sprintf "ELet(%s, %s, %s)" n es bs
        | EIf(c, t, e) ->
            let cs = (string_of_expr c) in
            let ts = (string_of_expr t) in
            let es = (string_of_expr e) in
            sprintf "EIf(%s, %s, %s)" cs ts es

and string_of_binop (op : binop) : string =
    match op with
        | Plus -> "Plus"
        | Minus -> "Minus"
