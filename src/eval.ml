open Internal
open Error

module Value = struct
  type t =
    | Integer of int
    | Boolean of bool
    | Closure of context * FunctionArgs.t * Type.t * Expression.t
    | Native of (t list -> t)
  [@@deriving show]

  and context = (Identifier.t * t) list [@@deriving show]
end

module Context = struct
  type t = Value.context

  let find id context =
    match List.find_opt (fun (n, _) -> n = id) context with
    | Some (_, v) ->
        v
    | None ->
        raise UnboundVariable

  let add binding context = binding :: context
end

let rec eval (context : Context.t) (expr : Expression.t) : Value.t =
  match expr with
  | Expression.Variable x ->
      Context.find x context
  | Expression.IntLiteral i ->
      Value.Integer i
  | Expression.BoolLiteral b ->
      Value.Boolean b
  | Expression.Let (x, t, b, c) ->
      let bv = eval context b in
      let new_ctx = Context.add (x, bv) context in
      eval new_ctx c
  | Expression.If (cond, then_br, else_br) -> (
      let cv = eval context cond in
      match cv with
      | Value.Boolean b ->
          if b then eval context then_br else eval context else_br
      | _ ->
          raise TypeException )
  | Expression.Function (args, ret_ty, body) ->
      Value.Closure (context, args, ret_ty, body)
  | Expression.Call (func, args) -> (
      let argvs = List.map (eval context) args in
      let clos = eval context func in
      match clos with
      | Value.Closure (bindings, pargs, ret_ty, body) ->
          let new_bindings =
            List.map
              (fun ((n, _), v) -> (Identifier.Name n, v))
              (List.combine pargs argvs)
          in
          eval (new_bindings @ bindings) body
      | Value.Native f ->
          f argvs
      | _ ->
          raise TypeException )
