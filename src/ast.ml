type id =
    | Id of string

type binop =
    | Add
    | Minus
    | Times

type unaop =
    | NOT

type expr =
    | Id of id
    | Int of int
    | Bool of bool
    | BinOp of binop * expr * expr
    | UnaOp of unaop * expr
    | Let of string * expr * expr
    | IF of expr * expr * expr
    | App of id * expr list
    | Function of id list * expr
