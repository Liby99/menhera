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

type unaop =
    | Not
    | Neg

type expr =
    | Var of string
    | Int of int
    | Bool of bool
    | BinOp of binop * expr * expr
    | UnaOp of unaop * expr
    | Let of id * expr * expr
    | If of expr * expr * expr
    | App of expr * expr list
    | Function of id list * expr

let rec to_string (e : expr) : string =
    match e with
        | Var(n) -> sprintf "Var(%s)" n
        | Int(i) -> sprintf "Int(%d)" i
        | Bool(b) -> if b then "Bool(true)" else "Bool(false)"
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
            in
            sprintf "BinOp(%s, %s, %s)" os (to_string e1) (to_string e2)
        | UnaOp(op, e) ->
            let os = match op with
                | Not -> "Not"
                | Neg -> "Neg"
            in
            sprintf "UnaOp(%s, %s)" os (to_string e)
        | Let(Id(n), e, b) -> sprintf "Let(Id(%s), %s, %s)" n (to_string e) (to_string b)
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
            let rec args_to_string args =
                match args with
                    | [] -> ""
                    | [ Id(a) ] -> "Id(" ^ a ^ ")"
                    | Id(a) :: rst -> "Id(" ^ a ^ "), " ^ (args_to_string rst)
            in
            sprintf "Function([%s], %s)" (args_to_string args) (to_string b)
