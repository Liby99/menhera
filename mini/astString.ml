open Printf
open Ast

let rec string_of_prog (p : prog) : string =
    match p with
        | Program(e) -> sprintf "Program(%s)" (string_of_expr e)

and string_of_list (f : 'a -> string) (ls : 'a list) : string = "[" ^ (String.concat ", " (List.map f ls)) ^ "]"

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
        | EUnaOp(op, e) ->
            let ops = (string_of_unaop op) in
            let es = (string_of_expr e) in
            sprintf "EUnaOp(%s, %s)" ops es
        | ELet(n, e, b) ->
            let es = (string_of_expr e) in
            let bs = (string_of_expr b) in
            sprintf "ELet(%s, %s, %s)" n es bs
        | EIf(c, t, e) ->
            let cs = (string_of_expr c) in
            let ts = (string_of_expr t) in
            let es = (string_of_expr e) in
            sprintf "EIf(%s, %s, %s)" cs ts es
        | EFunction(args, body) ->
            let argss = string_of_list (fun (x : string) : string -> x) args in
            let bs = (string_of_expr body) in
            sprintf "EFunction(%s, %s)" argss bs
        | EApp(f, args) ->
            let fs = string_of_expr f in
            let argss = "[" ^ (String.concat ", " (List.map string_of_expr args)) ^ "]" in (* TODO: Fix this! *)
            (* let argss = string_of_list string_of_expr args in *)
            sprintf "EApp(%s, %s)" fs argss

and string_of_binop (op : binop) : string =
    match op with
        | Plus -> "Plus"
        | Minus -> "Minus"
        | And -> "And"
        | Or -> "Or"
        | Equal -> "Equal"
        | Inequal -> "Inequal"
        | Greater -> "Greater"
        | GreaterOrEqual -> "GreaterOrEqual"
        | Less -> "Less"
        | LessOrEqual -> "LessOrEqual"

and string_of_unaop (op : unaop) : string =
    match op with
        | Not -> "Not"
