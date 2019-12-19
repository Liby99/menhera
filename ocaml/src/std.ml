open Internal
open Error

type t = Identifier.t * Type.t * Value.t

let int_plus = (
  (Identifier.BinOp (
    BinaryOperation.Plus,
    Type.Base "int",
    Type.Base "int"
  )),
  (Type.Function (
    [Type.Base "int"; Type.Base "int"],
    Type.Base "int"
  )),
  (Value.Native
    (fun args ->
      match args with
      | [v1; v2] ->
          (match v1, v2 with
          | Value.Integer i1, Value.Integer i2 -> Value.Integer (i1 + i2)
          | _, _ -> raise TypeException)
      | _ -> raise ArgumentException)))

let stdlib = [int_plus]

let stdctx = List.map (fun (id, _, value) -> (id, value)) stdlib

let stdctx_typing = List.map (fun (id, ty, _) -> (id, ty)) stdlib