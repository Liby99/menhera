open Error
open Internal
open Eval

type t = Identifier.t * Type.t * Value.t

let int_int_op bop ret_ty op =
  ( Identifier.BinOp (bop, Type.Base "int", Type.Base "int")
  , Type.Function ([Type.Base "int"; Type.Base "int"], ret_ty)
  , Value.Native
      (fun args ->
        match args with
        | [v1; v2] -> (
          match (v1, v2) with
          | Value.Integer i1, Value.Integer i2 ->
              op i1 i2
          | _, _ ->
              raise TypeException )
        | _ ->
            raise ArgumentException) )

let int_plus_int =
  int_int_op BinaryOperation.Plus (Type.Base "int") (fun i1 i2 ->
      Value.Integer (i1 + i2))

let int_minus_int =
  int_int_op BinaryOperation.Minus (Type.Base "int") (fun i1 i2 ->
      Value.Integer (i1 - i2))

let int_multiply_int =
  int_int_op BinaryOperation.Multiply (Type.Base "int") (fun i1 i2 ->
      Value.Integer (i1 * i2))

let int_divide_int =
  int_int_op BinaryOperation.Divide (Type.Base "int") (fun i1 i2 ->
      Value.Integer (i1 / i2))

let int_equal_int =
  int_int_op BinaryOperation.Equal (Type.Base "bool") (fun i1 i2 ->
      Value.Boolean (i1 = i2))

let bool_bool_op bop ret_ty op =
  ( Identifier.BinOp (bop, Type.Base "bool", Type.Base "bool")
  , Type.Function ([Type.Base "bool"; Type.Base "bool"], ret_ty)
  , Value.Native
      (fun args ->
        match args with
        | [v1; v2] -> (
          match (v1, v2) with
          | Value.Boolean b1, Value.Boolean b2 ->
              op b1 b2
          | _, _ ->
              raise TypeException )
        | _ ->
            raise ArgumentException) )

let bool_and_bool =
  bool_bool_op BinaryOperation.And (Type.Base "bool") (fun b1 b2 ->
      Value.Boolean (b1 && b2))

let bool_or_bool =
  bool_bool_op BinaryOperation.And (Type.Base "bool") (fun b1 b2 ->
      Value.Boolean (b1 || b2))

let bool_equal_bool =
  bool_bool_op BinaryOperation.Equal (Type.Base "bool") (fun b1 b2 ->
      Value.Boolean (b1 = b2))

let recursive =
  let r args =
    match args with
    | [Value.Closure (bindings, [(n, _)], _, rec_func)] -> (
      match rec_func with
      | Expression.Function (pargs, _, rec_func_body) ->
          let rec f vargs =
            let nbs =
              List.map
                (fun ((n, _), v) -> (Identifier.Name n, v))
                (List.combine pargs vargs)
            in
            let fb = (Identifier.Name n, Value.Native f) in
            eval ((fb :: nbs) @ bindings) rec_func_body
          in
          Value.Native f
      | _ ->
          raise TypeException )
    | _ ->
        raise ArgumentException
  in
  ( Identifier.Name "rec"
  , Type.Function ([Type.Poly "a"], Type.Poly "a")
  , Value.Native r )

let stdlib =
  [ int_plus_int
  ; int_minus_int
  ; int_multiply_int
  ; int_divide_int
  ; int_equal_int
  ; bool_and_bool
  ; bool_or_bool
  ; bool_equal_bool
  ; recursive ]

let stdctx = List.map (fun (id, _, value) -> (id, value)) stdlib

let stdctx_typing = List.map (fun (id, ty, _) -> (id, ty)) stdlib
