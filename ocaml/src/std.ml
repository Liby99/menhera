open Error
open Internal
open Eval

type t = Identifier.t * Type.t * Value.t

let int_int_op bop ret_ty op =
  Identifier.BinOp (bop, Type.Base "int", Type.Base "int"),
  Type.Function ([Type.Base "int"; Type.Base "int"], ret_ty),
  (Value.Native
    (fun args ->
      match args with
      | [v1; v2] ->
          (match v1, v2 with
          | Value.Integer i1, Value.Integer i2 -> (op i1 i2)
          | _, _ -> raise TypeException)
      | _ -> raise ArgumentException))

let int_plus_int =
  int_int_op
    BinaryOperation.Plus
    (Type.Base "int")
    (fun i1 i2 -> Value.Integer (i1 + i2))

let int_minus_int =
  int_int_op
    BinaryOperation.Minus
    (Type.Base "int")
    (fun i1 i2 -> Value.Integer (i1 - i2))

let int_multiply_int =
  int_int_op
    BinaryOperation.Multiply
    (Type.Base "int")
    (fun i1 i2 -> Value.Integer (i1 * i2))

let int_divide_int =
  int_int_op
    BinaryOperation.Divide
    (Type.Base "int")
    (fun i1 i2 -> Value.Integer (i1 / i2))

let int_equal_int =
  int_int_op
    BinaryOperation.Equal
    (Type.Base "bool")
    (fun i1 i2 -> Value.Boolean (i1 = i2))

let recursive =
  Identifier.Name "rec",
  (Type.Function ([Type.Poly "a"], Type.Poly "a")),
  (Value.Native
    (fun args ->
      match args with
      | [a0] ->
          (match a0 with
          | Value.Closure (bindings, [(n, t)], ret_ty, rec_func) ->
              let rec_func_val = eval bindings rec_func in
              eval
                ((Identifier.Name n, rec_func_val) :: bindings)
                (Expression.Call (
                  Expression.Function ([(n, t)], ret_ty, rec_func),
                  [rec_func]))
          | _ -> raise TypeException)
      | _ -> raise ArgumentException))

let stdlib =
  [ int_plus_int
  ; int_minus_int
  ; int_multiply_int
  ; int_divide_int
  ; int_equal_int
  ; recursive ]

let stdctx = List.map (fun (id, _, value) -> (id, value)) stdlib

let stdctx_typing = List.map (fun (id, ty, _) -> (id, ty)) stdlib