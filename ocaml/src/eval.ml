open Internal
open Error

let rec eval (context : Context.t) (expr : Expression.t) : Value.t =
  match expr with
  | Expression.Variable x ->
      Context.find x context
  | Expression.IntLiteral i ->
      Value.Integer i
  | Expression.BoolLiteral b ->
      Value.Boolean b
  | Expression.LetExpr (x, t, b, c) ->
      let bv = eval context b in
      let new_ctx = Context.add (x, bv) context in
      eval new_ctx c
  | Expression.IfExpr (cond, then_br, else_br) ->
      let cv = eval context cond in
      (match cv with
      | Value.Boolean b ->
          if b then eval context then_br
          else eval context else_br
      | _ -> raise TypeException)
  | Expression.Function (args, ret_ty, body) ->
      Value.Closure (context, args, ret_ty, body)
  | Expression.Call (func, args) ->
      let argvs = List.map (eval context) args in
      let clos = eval context func in
      (match clos with
      | Value.Closure (bindings, argts, ret_ty, body) ->
          let new_bindings =
            List.map
              (fun (v, (n, _)) -> (Identifier.Name n, v))
              (List.combine argvs argts)
          in
          eval (new_bindings @ bindings) body
      | Value.Native f -> f argvs
      | _ -> raise TypeException)