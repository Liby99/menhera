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

module Identifier = struct
  type t =
    | Ignore
    | Name of string
    | BinOp of BinaryOperation.t * Type.t * Type.t
    | UnaOp of UnaryOperation.t * Type.t * Type.t
end

module Expression = struct
  type t =
    | Variable of Identifier.t
    | IntLiteral of int
    | BoolLiteral of bool
    | LetExpr of Identifier.t * Type.t * t * t
    | IfExpr of t * t * t
    | Function of (string * Type.t) list * Type.t * t
    | Call of t * t list
end

module Value = struct
  type t =
    | Integer of int
    | Boolean of bool
    | Closure of context * (string * Type.t) list * Type.t * Expression.t
    | Native of (t list -> t)

  and context = (Identifier.t * t) list
end

module Context = struct
  type t = Value.context

  let find id context =
    List.find (fun (n, _) -> n = id) context |> snd

  let add binding context =
    binding :: context
end

exception TypeException

exception ArgumentException

module StdLib = struct
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

  let stdlib : t list = [int_plus]

  let std_context = List.map (fun (id, _, value) -> (id, value)) stdlib

  let std_typing_context = List.map (fun (id, ty, _) -> (id, ty)) stdlib
end

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

let arith_example =
  Expression.Call (
    Expression.Variable
      (Identifier.BinOp (
        BinaryOperation.Plus,
        Type.Base "int",
        Type.Base "int"
      )),
    [ Expression.IntLiteral 1
    ; Expression.IntLiteral 2 ])

let sum_example =
  Expression.LetExpr (
    Identifier.Name "sum",
    Type.Function (
      [ Type.Base "int"
      ; Type.Base "int" ],
      Type.Base "int"
    ),
    Expression.Function (
      [ ("x", Type.Base "int")
      ; ("y", Type.Base "int") ],
      Type.Base "int",
      Expression.Call (
        Expression.Variable
          (Identifier.BinOp (
            BinaryOperation.Plus,
            Type.Base "int",
            Type.Base "int"
          )),
        [ Expression.Variable (Identifier.Name "x")
        ; Expression.Variable (Identifier.Name "y") ]
      )
    ),
    Expression.Call (
      (Expression.Variable (Identifier.Name "sum")),
      [ Expression.IntLiteral 4
      ; Expression.IntLiteral 5 ]
    )
  )

let main filename =
  let result = eval StdLib.std_context sum_example in
  match result with
  | Value.Integer i ->
      Printf.printf "Arith result %d\n" i ;
      ()
  | _ -> ()

;;

main "example/arith.mhr"