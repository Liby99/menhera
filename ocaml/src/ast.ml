exception TypeException

module BinaryOperation = struct
  type t =
    | Plus
    | Minus
    | Multiply
    | Divide
end

module UnaryOperation = struct
  type t =
    | Negate
end

module Type = struct
  type t =
    | Top
    | Unit
    | Base of string
    | Function of (t list) * t
end

module Expression = struct
  type t =
    | Variable of string
    | IntLiteral of int
    | LetExpr of string * Type.t * t * t
    | BinaryExpr of BinaryOperation.t * t * t
    | UnaryExpr of UnaryOperation.t * t
    | Function of (string * Type.t) list * Type.t * t
    | Call of t * t list
end

module Value = struct
  type t =
    | Integer of int
    | Closure of context * (string * Type.t) list * Type.t * Expression.t

  and context = (string * t) list
end

module Context = struct
  type t = Value.context

  let find name context =
    List.find (fun (n, _) -> n = name) context |> snd

  let add_binding name value context =
    (name, value) :: context
end

let rec eval (context : Context.t) (expr : Expression.t) : Value.t =
  match expr with
  | Expression.Variable x ->
      Context.find x context
  | Expression.IntLiteral i ->
      Value.Integer i
  | Expression.LetExpr (x, t, b, c) ->
      let bv = eval context b in
      let new_ctx = Context.add_binding x bv context in
      eval new_ctx c
  | Expression.BinaryExpr (op, x, y) ->
      let xv = eval context x in
      let yv = eval context y in
      (match xv, yv with
      | Value.Integer xi, Value.Integer yi ->
          (match op with
          | BinaryOperation.Plus -> Value.Integer (xi + yi)
          | BinaryOperation.Minus -> Value.Integer (xi - yi)
          | BinaryOperation.Multiply -> Value.Integer (xi * yi)
          | BinaryOperation.Divide -> Value.Integer (xi / yi))
      | _, _ ->
          raise TypeException)
  | Expression.UnaryExpr (op, x) ->
      let xv = eval context x in
      (match xv with
      | Value.Integer xi ->
          (match op with
          | UnaryOperation.Negate -> Value.Integer (-xi))
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
              (fun (v, (n, _)) -> (n, v))
              (List.combine argvs argts)
          in
          eval (new_bindings @ bindings) body
      | _ -> raise TypeException)