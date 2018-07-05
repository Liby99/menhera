type unaop =
    | Not

type binop =
    | Plus
    | Minus
    | And
    | Or
    | Equal
    | Inequal
    | Greater
    | GreaterOrEqual
    | Less
    | LessOrEqual

type expr =
    | EId of string
    | EInt of int
    | EBool of bool
    | EBinOp of binop * expr * expr
    | EUnaOp of unaop * expr
    | ELet of string * expr * expr
    | EIf of expr * expr * expr

type prog =
    | Program of expr
