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

type typ =
  | UnitType of string
  | FunctionType of typ list * typ

type var =
  | Var of string
  | TypedVar of string * typ

type expr =
  | EId of string
  | EInt of int
  | EBool of bool
  | EBinOp of binop * expr * expr
  | EUnaOp of unaop * expr
  | ELet of var * expr * expr
  | EIf of expr * expr * expr
  | EFunction of var list * typ option * expr
  | EApp of expr * expr list

type prog =
  | Program of expr

let name_of_var (v : var) : string =
  match v with
    | Var(x) -> x
    | TypedVar(x, _) -> x

let type_of_var (v : var) : typ option =
  match v with
    | Var(_) -> None
    | TypedVar(_, t) -> Some(t)
