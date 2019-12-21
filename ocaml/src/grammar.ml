type binop =
  | Plus
  | Minus
  | Multiply
  | Divide
  | And
  | Or
  | Equal

type unaop =
  | Not
  | Negate

type id =
  | Id of string
  | BinOpId of binop
  | UnaOpId of unaop

type ty =
  | TyId of string
  | TyPoly of string
  | TyApply of ty * ty list

type vardef =
  | VarDef of id
  | VarDefWithType of id * ty

type expr =
  | Var of string
  | Int of int
  | Bool of bool
  | BinOp of binop * t * t
  | UnaOp of unaop * t * t
  | Let of id * ty option * t * t
  | If of t * t * t
  | Function of (string * ty option) list * ty option * t
  | Call of t * t list