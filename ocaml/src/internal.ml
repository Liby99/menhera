module BinaryOperation = struct
  type t =
    | Plus
    | Minus
    | Multiply
    | Divide
    | And
    | Or
end

module UnaryOperation = struct
  type t =
    | Not
    | Negate
end

module Type = struct
  type t =
    | Top
    | Unit
    | Base of string
    | Function of (t list) * t
end

module Identifier = struct
  type t =
    | Ignore
    | Name of string
    | BinOp of BinaryOperation.t * Type.t * Type.t
    | UnaOp of UnaryOperation.t * Type.t * Type.t
end

module Expression = struct
  type t =
    | Variable of Identifier.t
    | IntLiteral of int
    | BoolLiteral of bool
    | LetExpr of Identifier.t * Type.t * t * t
    | IfExpr of t * t * t
    | Function of (string * Type.t) list * Type.t * t
    | Call of t * t list
end

module Value = struct
  type t =
    | Integer of int
    | Boolean of bool
    | Closure of context * (string * Type.t) list * Type.t * Expression.t
    | Native of (t list -> t)

  and context = (Identifier.t * t) list
end

module Context = struct
  type t = Value.context

  let find id context =
    List.find (fun (n, _) -> n = id) context |> snd

  let add binding context =
    binding :: context
end