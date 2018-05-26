open Printf

type id =
    | Id of string

type binop =
    | Plus
    | Minus
    | Times
    | Divide
    | Greater
    | GreaterOrEqual
    | Less
    | LessOrEqual
    | Equals
    | And
    | Or
    | Concat
    | ListGet

type unaop =
    | Not
    | Neg
    | Length

type expr =
    | Var of string
    | Int of int
    | Bool of bool
    | List of expr list
    | BinOp of binop * expr * expr
    | UnaOp of unaop * expr
    | Let of (id * expr) list * expr
    | If of expr * expr * expr
    | App of expr * expr list
    | Function of id list * expr

let rec to_string (e : expr) : string =
    match e with
        | Var(n) -> sprintf "Var(\"%s\")" n
        | Int(i) -> sprintf "Int(%d)" i
        | Bool(b) ->
            if b
                then "Bool(true)"
                else "Bool(false)"
        | List(es) ->
            let rec exps_to_string es =
                match es with
                    | [] -> ""
                    | [ e ] -> (to_string e)
                    | e :: rst -> (to_string e) ^ ", " ^ (exps_to_string rst)
            in
            sprintf "List(%s)" (exps_to_string es)
        | BinOp(op, e1, e2) ->
            let os = match op with
                | Plus -> "Plus"
                | Minus -> "Minus"
                | Times -> "Times"
                | Divide -> "Divide"
                | Greater -> "Greater"
                | GreaterOrEqual -> "GreaterOrEqual"
                | Less -> "Less"
                | LessOrEqual -> "LessOrEqual"
                | Equals -> "Equals"
                | And -> "And"
                | Or -> "Or"
                | Concat -> "Concat"
                | ListGet -> "ListGet"
            in
            sprintf "BinOp(%s, %s, %s)" os (to_string e1) (to_string e2)
        | UnaOp(op, e) ->
            let os = match op with
                | Not -> "Not"
                | Neg -> "Neg"
                | Length -> "Length"
            in
            sprintf "UnaOp(%s, %s)" os (to_string e)
        | Let(bs, body) ->
            let binding_to_string b =
                match b with
                    | (Id(n), e) -> sprintf "(Id(%s), %s)" n (to_string e)
            in
            let rec bindings_to_string bs =
                match bs with
                    | [] -> ""
                    | [ b ] -> binding_to_string b
                    | b :: rst -> (binding_to_string b) ^ ", " ^ (bindings_to_string rst)
            in
            sprintf "Let([%s], %s)" (bindings_to_string bs) (to_string body)
        | If(c, t, e) -> sprintf "If(%s, %s, %s)" (to_string c) (to_string t) (to_string e)
        | App(f, es) ->
            let rec exp_ls_to_string es =
                match es with
                    | [] -> ""
                    | [ e ] -> (to_string e)
                    | e :: rst -> (to_string e) ^ ", " ^ (exp_ls_to_string rst)
            in
            sprintf "App(%s, [%s])" (to_string f) (exp_ls_to_string es)
        | Function(args, b) ->
            let id_to_string id =
                match id with
                    | Id(n) -> "Id(\"" ^ n ^ "\")"
            in
            let rec args_to_string args =
                match args with
                    | [] -> ""
                    | [ i ] -> id_to_string i
                    | i :: rst -> (id_to_string i) ^ ", " ^ (args_to_string rst)
            in
            sprintf "Function([%s], %s)" (args_to_string args) (to_string b)
