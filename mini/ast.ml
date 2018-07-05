type binop =
    | Plus
    | Minus

type expr =
    | EId of string
    | EInt of int
    | EBinOp of binop * expr * expr
    | ELet of string * expr * expr

type prog =
    | Program of expr
