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
    | ListGet

type unaop =
    | Not
    | Neg
    | Length

type expr =
    | Var of string
    | Int of int
    | Bool of bool
    | String of string
    | List of expr list
    | BinOp of binop * expr * expr
    | UnaOp of unaop * expr
    | Let of (id * expr) list * expr
    | If of expr * expr * expr
    | App of expr * expr list
    | Function of id list * expr

(* TODO: From AST to program *)
let rec to_prog (e : expr) : string =
    match e with
        | Var(n) -> n
        | Int(i) -> sprintf "%d" i
        | Bool(b) -> if b then "true" else "false"
        | String(s) -> sprintf "\"%s\"" s
        | List(es) ->
            let rec exps_to_prog es =
                match es with
                    | [] -> ""
                    | [ e ] -> to_prog e
                    | e :: rst -> (to_prog e) ^ ", " ^ (exps_to_prog rst)
            in
            sprintf "[%s]" (exps_to_prog es)
        | BinOp(op, e1, e2) ->
            let (ops, reg) = match op with
                | Plus -> ("+", true)
                | Minus -> ("-", true)
                | Times -> ("*", true)
                | Divide -> ("/", true)
                | Greater -> (">", true)
                | GreaterOrEqual -> (">=", true)
                | Less -> ("<", true)
                | LessOrEqual -> ("<=", true)
                | Equals -> ("==", true)
                | And -> ("&&", true)
                | Or -> ("||", true)
                | ListGet -> ("", false)
            in
            if reg
                then "(" ^ (to_prog e1) ^ " " ^ ops ^ " " ^ (to_prog e2) ^ ")"
                else
                    (match op with
                        | ListGet -> "(" ^ (to_prog e1) ^ "[" ^ (to_prog e2) ^ "])"
                        | _ -> failwith "Unknown to_prog error in BinOp")
        | UnaOp(op, e) ->
            let (ops, reg) = match op with
                | Not -> ("!", true)
                | Neg -> ("-", true)
                | Length -> ("", false)
            in
            if reg
                then "(" ^ ops ^ "(" ^ (to_prog e) ^ "))"
                else
                    (match op with
                        | Length -> "(|" ^ (to_prog e) ^ "|)"
                        | _ -> failwith "Unknown to_prog error in UnaOp")
        | Let(bs, body) ->
            let rec binding_to_prog b =
                match b with
                    | (Id(n), e) -> sprintf "%s = %s" n (to_prog e)
            in
            let rec bindings_to_prog bs =
                match bs with
                    | [] -> ""
                    | [ b ] -> (binding_to_prog b)
                    | b :: rst -> (binding_to_prog b) ^ ", " ^ (bindings_to_prog rst)
            in
            sprintf "let %s in %s" (bindings_to_prog bs) (to_prog body)
        | If(c, t, e) -> sprintf "if %s then %s else %s" (to_prog c) (to_prog t) (to_prog e)
        | App(f, es) ->
            let rec exps_to_prog es =
                match es with
                    | [] -> ""
                    | [ e ] -> (to_prog e)
                    | e :: rst -> (to_prog e) ^ ", " ^ (exps_to_prog rst)
            in
            let fs = match f with
                | Var(n) -> n
                | _ -> "(" ^ (to_prog f) ^ ")"
            in
            sprintf "%s(%s)" fs (exps_to_prog es)
        | Function(args, body) ->
            let rec args_to_prog args =
                match args with
                    | [] -> ""
                    | [ Id(a) ] -> a
                    | Id(a) :: rst -> a ^ ", " ^ (args_to_prog rst)
            in
            sprintf "(%s) => %s" (args_to_prog args) (to_prog body)

let rec to_string (e : expr) : string =
    match e with
        | Var(n) -> sprintf "Var(\"%s\")" n
        | Int(i) -> sprintf "Int(%d)" i
        | Bool(b) -> if b then "Bool(true)" else "Bool(false)"
        | String(s) -> sprintf "String(\"%s\")" s
        | List(es) ->
            let rec exps_to_string es =
                match es with
                    | [] -> ""
                    | [ e ] -> to_string e
                    | e :: rst -> (to_string e) ^ ", " ^ (exps_to_string rst)
            in
            sprintf "List([%s])" (exps_to_string es)
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
