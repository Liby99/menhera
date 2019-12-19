open Internal
open Error
open Std
open Eval

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

let main _ =
  let result = eval stdctx sum_example in
  match result with
  | Value.Integer i ->
      Printf.printf "Arith result %d\n" i ;
      ()
  | _ -> ()

;;

main "example/arith.mhr"