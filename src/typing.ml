open Error
open Grammar
open Internal

module TypingContext = struct
  type t = (Identifier.t * Type.t) list

  let find id ctx =
    match List.find_opt (fun (x, _) -> x = id) ctx with
    | Some (_, t) ->
        Some t
    | None ->
        None
end

let internalize_bop bop t1 t2 =
  let bop =
    match bop with
    | Plus ->
        BinaryOperation.Plus
    | Minus ->
        BinaryOperation.Minus
    | Multiply ->
        BinaryOperation.Multiply
    | Divide ->
        BinaryOperation.Divide
    | And ->
        BinaryOperation.And
    | Or ->
        BinaryOperation.Or
    | Equal ->
        BinaryOperation.Equal
  in
  Identifier.BinOp (bop, t1, t2)

let internalize_uop uop t =
  let uop =
    match uop with
    | Not ->
        UnaryOperation.Not
    | Negate ->
        UnaryOperation.Negate
  in
  Identifier.UnaOp (uop, t)

let internalize_id id ty =
  match id with
  | Ignore ->
      Identifier.Ignore
  | Id x ->
      Identifier.Name x
  | BinOpId bop -> (
    match ty with
    | Type.Function ([t1; t2], _) ->
        internalize_bop bop t1 t2
    | _ ->
        raise TypeException )
  | UnaOpId uop -> (
    match ty with
    | Type.Function ([t], _) ->
        internalize_uop uop t
    | _ ->
        raise TypeException )

let rec internalize_ty ty =
  match ty with
  | TyId x ->
      Type.Base x
  | TyFunction (ts, rt) ->
      Type.Function (List.map internalize_ty ts, internalize_ty rt)

let rec type_of ctx ast =
  match ast with
  | Var x -> (
    match TypingContext.find (Identifier.Name x) ctx with
    | Some ty ->
        ty
    | None ->
        raise UnboundVariable )
  | Int _ ->
      Type.Base "int"
  | Bool _ ->
      Type.Base "bool"
  | BinOp (bop, e1, e2) -> (
      let t1 = type_of ctx e1 in
      let t2 = type_of ctx e2 in
      let op = internalize_bop bop t1 t2 in
      let mbty = TypingContext.find op ctx in
      match mbty with
      | Some (Type.Function (_, ret_ty)) ->
          ret_ty
      | _ ->
          raise TypeException )
  | UnaOp (uop, e) -> (
      let t = type_of ctx e in
      let op = internalize_uop uop t in
      let mbty = TypingContext.find op ctx in
      match mbty with
      | Some (Type.Function (_, ret_ty)) ->
          ret_ty
      | _ ->
          raise TypeException )
  | If (c, t, e) ->
      let ct = type_of ctx c in
      let tt = type_of ctx t in
      let et = type_of ctx e in
      if ct = Type.Base "bool" && tt = et then tt else raise TypeException
  | Let (x, _, b, c) -> (
      let tb = type_of ctx b in
      let id = internalize_id x tb in
      match x with Ignore -> type_of ctx c | _ -> type_of ((id, tb) :: ctx) c )
  | Function (args, mbr, _) ->
      let argst =
        List.map
          (fun (_, mbt) ->
            match mbt with
            | Some t ->
                internalize_ty t
            | None ->
                raise MustBeTyped)
          args
      in
      let rett =
        match mbr with Some r -> internalize_ty r | None -> raise MustBeTyped
      in
      Type.Function (argst, rett)
  | Call (f, _) -> (
      let f_ty = type_of ctx f in
      match f_ty with
      | Type.Function (_, ret_ty) ->
          ret_ty
      | _ ->
          raise TypeException )

let rec internalize ctx ast =
  match ast with
  | Grammar.Var x ->
      Expression.Variable (Identifier.Name x)
  | Grammar.Int i ->
      Expression.IntLiteral i
  | Grammar.Bool b ->
      Expression.BoolLiteral b
  | Grammar.BinOp (bop, e1, e2) ->
      let t1 = type_of ctx e1 in
      let t2 = type_of ctx e2 in
      Expression.Call
        ( Expression.Variable (internalize_bop bop t1 t2)
        , [internalize ctx e1; internalize ctx e2] )
  | Grammar.UnaOp (uop, e) ->
      let t = type_of ctx e in
      Expression.Call
        (Expression.Variable (internalize_uop uop t), [internalize ctx e])
  | Grammar.Let (x, t, b, c) -> (
      let tb = type_of ctx b in
      let id = internalize_id x tb in
      let _ =
        match t with
        | Some t ->
            let tx = internalize_ty t in
            if tx = tb then () else raise TypeException
        | None ->
            ()
      in
      match x with
      | Ignore ->
          Expression.Let
            (Identifier.Ignore, tb, internalize ctx b, internalize ctx c)
      | _ ->
          Expression.Let
            (id, tb, internalize ctx b, internalize ((id, tb) :: ctx) c) )
  | Grammar.If (c, t, e) ->
      Expression.If (internalize ctx c, internalize ctx t, internalize ctx e)
  | Grammar.Function (args, mbr, body) ->
      let new_ctx, itn_args =
        List.fold_left
          (fun (ctx, itn_args) (arg, mbty) ->
            let ty =
              match mbty with
              | Some ty ->
                  internalize_ty ty
              | None ->
                  raise MustBeTyped
            in
            match arg with
            | Id x ->
                let new_ctx = (Identifier.Name x, ty) :: ctx in
                let new_itn_args = (x, ty) :: itn_args in
                (new_ctx, new_itn_args)
            | Ignore ->
                (ctx, ("_", ty) :: itn_args)
            | _ ->
                raise InvalidFunctionArgument)
          (ctx, []) args
      in
      let ret_ty =
        match mbr with Some r -> internalize_ty r | None -> raise MustBeTyped
      in
      Expression.Function (itn_args, ret_ty, internalize new_ctx body)
  | Grammar.Call (f, args) ->
      Expression.Call (internalize ctx f, List.map (internalize ctx) args)
