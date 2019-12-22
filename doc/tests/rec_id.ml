let rec_id_example =
  Expression.Let (
    Identifier.Name "f",
    Type.Function ([ Type.Base "int" ], Type.Base "int"),
    Expression.Call (
      Expression.Variable (Identifier.Name "rec"),
      [ Expression.Function (
        [ ("f", Type.Function ([ Type.Base "int" ], Type.Base "int")) ],
        Type.Function ([ Type.Base "int" ], Type.Base "int"),
        Expression.Function (
          [ ("x", Type.Base "int") ],
          Type.Base "int",
          Expression.If (
            Expression.Call (
              Expression.Variable (
                Identifier.BinOp (
                  BinaryOperation.Equal,
                  Type.Base "int",
                  Type.Base "int"
                ) ),
              [ Expression.Variable (Identifier.Name "x")
              ; Expression.IntLiteral 0 ] ),
            Expression.IntLiteral 0,
            Expression.Call (
              Expression.Variable (
                Identifier.BinOp (
                  BinaryOperation.Plus,
                  Type.Base "int",
                  Type.Base "int"
                ) ),
              [ Expression.IntLiteral 1
              ; Expression.Call (
                Expression.Variable (Identifier.Name "f"),
                [ Expression.Call (
                  Expression.Variable (
                    Identifier.BinOp (
                      BinaryOperation.Minus,
                      Type.Base "int",
                      Type.Base "int"
                    ) ),
                  [ Expression.Variable (Identifier.Name "x")
                  ; Expression.IntLiteral 1 ]
                ) ] ) ] ) ) ) ) ] ),
    Expression.Call (
      Expression.Variable (Identifier.Name "f"),
      [ Expression.IntLiteral 10 ]
    ) )