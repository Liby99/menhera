module BinaryOperation = struct
  type t =
    | Plus
    | Minus
    | Multiply
    | Divide
    | And
    | Or
    | Equal

  let to_string op =
    match op with
    | Plus -> "Plus"
    | Minus -> "Minus"
    | Multiply -> "Multiply"
    | Divide -> "Divide"
    | And -> "And"
    | Or -> "Or"
    | Equal -> "Equal"
end

module UnaryOperation = struct
  type t =
    | Not
    | Negate

  let to_string op =
    match op with
    | Not -> "Not"
    | Negate -> "Negate"
end

module Type = struct
  type t =
    | Unit
    | Base of string
    | Named of string
    | Poly of string
    | Function of t list * t

  let rec to_string ty =
    match ty with
    | Unit -> "Unit"
    | Base base -> Printf.sprintf "Base(%s)" base
    | Named name -> Printf.sprintf "Named(%s)" name
    | Poly name -> Printf.sprintf "Poly(%s)" name
    | Function (args, ret) ->
        Printf.sprintf "Function([%s], %s)"
          (String.concat "," (List.map to_string args))
          (to_string ret)
end

module Identifier = struct
  type t =
    | Ignore
    | Name of string
    | BinOp of BinaryOperation.t * Type.t * Type.t
    | UnaOp of UnaryOperation.t * Type.t * Type.t

  let to_string id =
    match id with
    | Ignore -> "Ignore"
    | Name name -> Printf.sprintf "Name(%s)" name
    | BinOp (binop, t1, t2) ->
        Printf.sprintf "BinOp(%s, %s, %s)"
          (BinaryOperation.to_string binop)
          (Type.to_string t1)
          (Type.to_string t2)
    | UnaOp (unaop, t1, t2) ->
        Printf.sprintf "UnaOp(%s, %s, %s"
          (UnaryOperation.to_string unaop)
          (Type.to_string t1)
          (Type.to_string t2)
end

module FunctionArgs = struct
  type t = (string * Type.t) list
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
end