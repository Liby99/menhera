type binop =
    | Plus
    | Minus

type expr =
    | EInt of int
    | EBinOp of binop * expr * expr

type prog =
    | Program of expr
