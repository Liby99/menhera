open Printf
open Ast

let string_of_list (f : 'a -> string) (ls : 'a list) : string =
  "[" ^ (String.concat ", " (List.map f ls)) ^ "]"

let string_of_strings : string list -> string = string_of_list (fun x -> x)

let string_of_binop (op : binop) : string =
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

let string_of_unaop (op : unaop) : string =
  match op with
    | Not -> "Not"

let rec string_of_type (t : typ) : string =
  match t with
    | UnitType(x) -> sprintf "UnitType(\"%s\")" x
    | FunctionType(ts, t) ->
      let tss = string_of_list string_of_type ts in
      let ts = string_of_type t in
      sprintf "FunctionType(%s, %s)" tss ts

let string_of_option (f : 'a -> string) (o : 'a option) : string =
  match o with
    | Some(a) -> sprintf "Some(%s)" (f a)
    | None -> "None"

let string_of_var (v : var) : string =
  match v with
    | Var(n) -> sprintf "Var(\"%s\")" n
    | TypedVar(n, t) -> sprintf "TypedVar(\"%s\", \"%s\")" n (string_of_type t)

let string_of_vars : var list -> string = string_of_list string_of_var

let rec string_of_expr (e : expr) : string =
  match e with
    | EId(n) -> sprintf "EId(\"%s\")" n
    | EInt(i) -> sprintf "EInt(%d)" i
    | EBool(b) -> sprintf "EBool(%s)" (if b then "true" else "false")
    | EBinOp(op, e1, e2) ->
      let ops = string_of_binop op in
      let e1s = string_of_expr e1 in
      let e2s = string_of_expr e2 in
      sprintf "EBinOp(%s, %s, %s)" ops e1s e2s
    | EUnaOp(op, e) ->
      let ops = string_of_unaop op in
      let es = string_of_expr e in
      sprintf "EUnaOp(%s, %s)" ops es
    | ELet(n, e, b) ->
      let ns = string_of_var n in
      let es = string_of_expr e in
      let bs = string_of_expr b in
      sprintf "ELet(%s, %s, %s)" ns es bs
    | EIf(c, t, e) ->
      let cs = string_of_expr c in
      let ts = string_of_expr t in
      let es = string_of_expr e in
      sprintf "EIf(%s, %s, %s)" cs ts es
    | EFunction(args, tyo, body) ->
      let argss = string_of_vars args in
      let tyos = string_of_option string_of_type tyo in
      let bs = string_of_expr body in
      sprintf "EFunction(%s, %s, %s)" argss tyos bs
    | EApp(f, args) ->
      let fs = string_of_expr f in
      let argss = string_of_list string_of_expr args in
      sprintf "EApp(%s, %s)" fs argss

and string_of_prog (p : prog) : string =
  match p with
    | Program(e) -> sprintf "Program(%s)" (string_of_expr e)
