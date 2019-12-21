type binop = Plus | Minus | Multiply | Divide | And | Or | Equal
[@@deriving show]

type unaop = Not | Negate [@@deriving show]

type id = Ignore | Id of string | BinOpId of binop | UnaOpId of unaop
[@@deriving show]

type ty = TyId of string | TyPoly of string | TyApply of ty * ty list
[@@deriving show]

type vardef = VarDef of id | VarDefWithType of id * ty [@@deriving show]

type expr =
  (* | Var of string *)
  | Int of int
  | Bool of bool
  | BinOp of binop * expr * expr
  | UnaOp of unaop * expr
  (* | Let of vardef * expr * expr
  | If of expr * expr * expr
  | Function of vardef list * ty option * expr
  | Call of expr * expr list *)
[@@deriving show]
