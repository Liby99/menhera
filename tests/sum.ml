let sum_example =
  Expression.Let (
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
        Expression.Variable (
          Identifier.BinOp (
            BinaryOperation.Plus,
            Type.Base "int",
            Type.Base "int"
          ) ),
        [ Expression.Variable (Identifier.Name "x")
        ; Expression.Variable (Identifier.Name "y") ]
      )
    ),
    Expression.Call (
      (Expression.Variable (Identifier.Name "sum") ),
      [ Expression.IntLiteral 4
      ; Expression.IntLiteral 5 ]
    )
  )