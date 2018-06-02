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

and string_of_id (t : id) : string =
    match t with
        | Id(n) -> sprintf "Id(\"%s\")" n
        | ModuleId(m, n) -> sprintf "ModuleId(\"%s\", \"%s\")" m n

and string_of_type_sig (t : type_sig) : string =
    match t with
        | UnitTypeSig(i) -> sprintf "UnitTypeSig(\"%s\")" (string_of_id i)
        | GenTypeSig(i, ts) -> sprintf "GenTypeSig(\"%s\", %s)" (string_of_id i) (string_of_list ts string_of_type_sig)
        | FuncTypeSig(ats, r) -> sprintf "FuncTypeSig(%s, %s)" (string_of_list ats string_of_type_sig) (string_of_type_sig r)
        | ListTypeSig(t) -> sprintf "ListTypeSig(%s)" (string_of_type_sig t)

and string_of_ctor (c : ctor_def) : string =
    match c with
        | UnitCtor(n) -> sprintf "UnitCtor(\"%s\")" n
        | CompCtor(n, ts) -> sprintf "CompCtor(\"%s\", %s)" n (string_of_list ts string_of_type_sig)

and string_of_type_def (t : type_def) : string =
    match t with
        | TypeDef(tds, ctors) -> sprintf "TypeDef(%s, %s)" (string_of_type_def_sig tds) (string_of_list ctors string_of_ctor)

and string_of_import (i : import) : string =
    match i with
        | Import(n) -> sprintf "Import(\"%s\")" n
        | ImportAs(m, n) -> sprintf "ImportAs(\"%s\", \"%s\")" m n

and string_of_binop (o : binop) : string =
    match op with
        | Plus -> "Plus"
        | Minus -> "Minus"
        | Times -> "Times"
        | Divide -> "Divide"
        | Mod -> "Mod"
        | And -> "And"
        | Or -> "Or"
        | Equal -> "Equal"
        | Inequal -> "Inequal"
        | Greater -> "Greater"
        | GreaterOrEqual -> "GreaterOrEqual"
        | Less -> "Less"
        | LessOrEqual -> "LessOrEqual"
        | ListGet -> "ListGet"

and string_of_unaop (o : unaop) : string =
    match op with
        | Not -> "Not"
        | Neg -> "Neg"
        | Str -> "Str"
        | Len -> "Len"

and string_of_operator (o : operator) : string =
    match o with
        | OperatorBin(op) -> string_of_binop op
        | OperatorUna(op) -> string_of_unaop op

and string_of_var_def (v : var_def) : string =
    match v with
        | Var(n) -> sprintf "Var(\"%s\")" n
        | VarWithType(n, t) -> sprintf "VarWithType(\"%s\", %s)" n (string_of_type_sig t)
        | Operator(op) -> sprintf "Operator(%s)" (string_of_operator op)
        | OperatorWithType(op, t) -> sprintf "OperatorWithType(%s, %s)" (string_of_operator op) (string_of_type_sig t)

and string_of_pattern (p : pattern) : string =
    match p with
        | PWildCard -> "PWildCard"
        | PId(id) -> sprintf "PId(\"%s\")" (string_of_id id)
        | PInt(i) -> sprintf "PInt(%d)" i
        | PBool(b) -> sprintf "PBool(%s)" (if b then "true" else "false")
        | PFloat(f) -> sprintf "PFloat(%f)" f
        | PString(s) -> sprintf "PString(\"%s\")" s
        | PList(ls) -> sprintf "PList(%s)" (string_of_list ls string_of_pattern)
        | PApp(p, ps) -> sprintf "PApp(%s, %s)" (string_of_pattern p) (string_of_list ps string_of_pattern)

and string_of_expr (e : expr) : string =
    match e with
        | EId(id) -> sprintf "EId(%s)" (string_of_id id)
        | EInt(i) -> sprintf "EInt(%d)" i
        | EBool(b) -> sprintf "EBool(%s)" (if b then "true" else "false")
        | EFloat(f) -> sprintf "EFloat(%f)" f
        | EString(s) -> sprintf "EString(\"%s\")" s
        | EList(es) -> sprintf "EList(%s)" (string_of_list es string_of_expr)
        | EBinOp(op, e1, e2) ->
            let ops = string_of_binop op in
            sprintf "EBinOp(%s, %s, %s)" ops (string_of_expr e1) (string_of_expr e2)
        | EUnaOp(op, e) ->
            let ops = string_of_unaop op in
            sprintf "EUnaOp(%s, %s)" ops (string_of_expr e)
        | ELet(bindings, body) ->
            let bs = string_of_list bindings (fun (v, e) -> sprintf "(%s, %s)" (string_of_var_def v) (string_of_expr e)) in
            sprintf "ELet(%s, %s)" bs (string_of_expr body)
        | EIf(c, t, e) -> sprintf "EIf(%s, %s, %s)" (string_of_expr c) (string_of_expr t) (string_of_expr e)
        | EMatch(t, ps) ->
            let pes = (string_of_list ps (fun (p, e) -> sprintf "(%s, %s)" (string_of_pattern p) (string_of_expr e))) in
            sprintf "EMatch(%s, %s)" (string_of_expr t) pes
        | EFunction(args, ret, body) ->
            let rets = match ret with
                | Some(t) -> string_of_type_sig t
                | None -> "None"
            in sprintf "EFunction(%s, %s, %s)" (string_of_list args string_of_var_def) rets (string_of_expr body)
        | EApp(f, args) -> sprintf "EApp(%s, %s)" (string_of_expr f) (string_of_list args string_of_expr)

and string_of_section (s : section) : string =
    match s with
        | TypeSect(td) -> sprintf "TypeSect(%s)" (string_of_type_def td)
        | ImportSect(is) -> sprintf "ImportSect(%s)" (string_of_list is string_of_import)
        | ModuleSect(es) -> sprintf "ModuleSect(%s)" (string_of_list es (fun (v, e) -> sprintf "(%s, %s)" (string_of_var_def v) (string_of_expr e)))
        | MainSect(e) -> sprintf "MainSect(%s)" (string_of_expr e)

and string_of_prog (t : prog) : string =
    match t with
        | Program(ss) -> sprintf "Program(%s)" (string_of_list ss string_of_section)
