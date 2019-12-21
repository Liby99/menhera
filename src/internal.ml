module BinaryOperation = struct
  type t = Plus | Minus | Multiply | Divide | And | Or | Equal
  [@@deriving show]
end

module UnaryOperation = struct
  type t = Not | Negate [@@deriving show]
end

module Type = struct
  type t =
    | Unit
    | Base of string
    | Named of string
    | Poly of string
    | Function of t list * t
  [@@deriving show]
end

module Identifier = struct
  type t =
    | Ignore
    | Name of string
    | BinOp of BinaryOperation.t * Type.t * Type.t
    | UnaOp of UnaryOperation.t * Type.t
  [@@deriving show]
end

module FunctionArgs = struct
  type t = (string * Type.t) list [@@deriving show]
end

module Expression = struct
  type t =
    | Variable of Identifier.t
    | IntLiteral of int
    | BoolLiteral of bool
    | Let of Identifier.t * Type.t * t * t
    | If of t * t * t
    | Function of FunctionArgs.t * Type.t * t
    | Call of t * t list
  [@@deriving show]
end
