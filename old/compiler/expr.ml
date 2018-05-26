type expr =
    | EApplication of string * (expr list)
    | EFunction of string * (string list) * expr
    | EIf of expr * expr * expr
    | EId of string
    | ENumber of int
    | EBool of bool
    | EChar of char
    | EArray of expr list
    | ETuple of expr * expr
    | EOp2 of operation2 * expr * expr
    | EOp1 of operation1 * expr

type operation2
    | OAdd
    | OMinus
    | OTimes
    | ODivide
    | OMod
    | OAnd
    | OOr
    | OBitXor
    | OBitOr
    | OBitAnd
    | OEquals
    | OGt
    | OLt
    | OGte
    | OLte
    | OConcat

type operation1
    | OIncrement
    | ODecrement
    | ONot
    | OBitNot
