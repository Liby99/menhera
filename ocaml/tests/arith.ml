let example =
  Expression.Call (
    Expression.Variable
      (Identifier.BinOp (
        BinaryOperation.Plus,
        Type.Base "int",
        Type.Base "int"
      )),
    [ Expression.IntLiteral 1
    ; Expression.IntLiteral 2 ] )

let result = Value.Integer 3