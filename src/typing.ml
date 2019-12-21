open Error
open Grammar
open Internal

module TypingContext = struct
  type t = (Identifier.t * Type.t) list

  let find = List.find_opt
end

let internalize_bop bop t1 t2 =
  let bop =
    match bop with
    | Plus -> BinaryOperation.Plus
    | Minus -> BinaryOperation.Minus
    | Multiply -> BinaryOperation.Multiply
    | Divide -> BinaryOperation.Divide
    | And -> BinaryOperation.And
    | Or -> BinaryOperation.Or
    | Equal -> BinaryOperation.Equal
  in
  Identifier.BinOp (bop, t1, t2)

let internalize_uop uop t =
  let uop = match uop with
    | Not -> UnaryOperation.Not
    | Negate -> UnaryOperation.Negate
  in
  Identifier.UnaOp (uop, t)

let rec type_of ctx ast =
  match ast with
  | Int _ -> Type.Base "int"
  | Bool _ -> Type.Base "bool"
  | BinOp (bop, e1, e2) ->
      let t1 = type_of ctx e1 in
      let t2 = type_of ctx e2 in
      let op = internalize_bop bop t1 t2 in
      let mbty = TypingContext.find (fun x -> fst x |> (=) op) ctx in (
      match mbty with
      | Some (_, Type.Function (_, ret_ty)) -> ret_ty
      | _ -> raise TypeException )
  | UnaOp (uop, e) ->
      let t = type_of ctx e in
      let op = internalize_uop uop t in
      let mbty = TypingContext.find (fun x -> fst x |> (=) op) ctx in (
      match mbty with
      | Some (_, Type.Function (_, ret_ty)) -> ret_ty
      | _ -> raise TypeException )

let rec internalize ctx ast =
  match ast with
  | Grammar.Int i ->
      Expression.IntLiteral i
  | Grammar.Bool b ->
      Expression.BoolLiteral b
  | Grammar.BinOp (bop, e1, e2) ->
      let t1 = type_of ctx e1 in
      let t2 = type_of ctx e2 in
      Expression.Call (
        Expression.Variable (internalize_bop bop t1 t2),
        [ internalize ctx e1
        ; internalize ctx e2 ] )
  | Grammar.UnaOp (uop, e) ->
      let t = type_of ctx e in
      Expression.Call (
        Expression.Variable (internalize_uop uop t),
        [ internalize ctx e ] )
