open Ast

let arith_example =
  Expression.BinaryExpr (
    BinaryOperation.Plus,
    (Expression.IntLiteral 1),
    (Expression.IntLiteral 2)
  )

let sum_example =
  Expression.LetExpr (
    "sum",
    Type.Function (
      [ Type.Base "int"
      ; Type.Base "int" ],
      Type.Base "int"
    ),
    Expression.Function (
      [ ("x", Type.Base "int")
      ; ("y", Type.Base "int") ],
      Type.Base "int",
      Expression.BinaryExpr (
        BinaryOperation.Plus,
        (Expression.Variable "x"),
        (Expression.Variable "y")
      )
    ),
    Expression.Call (
      (Expression.Variable "sum"),
      [ Expression.IntLiteral 4
      ; Expression.IntLiteral 5 ]
    )
  )

let main filename =
  let result = eval [] sum_example in
  match result with
  | Value.Integer i ->
      Printf.printf "Arith result %d\n" i ;
      ()
  | _ -> ()

;;

main "example/arith.mhr"