(*
 * Program:
 *
 * ```
 * let fib = rec((fib) => (x) => {
 *   if x == 0 then 0
 *   else if x == 1 then 1
 *   else fib(x - 1) + fib(x - 2)
 * })
 * ```
 *)

let fib_example =
  Expression.Let (
    Identifier.Name "fib",
    Type.Function ([ Type.Base "int" ], Type.Base "int"),
    Expression.Call (
      Expression.Variable (Identifier.Name "rec"),
      [Expression.Function (
        [ ("fib", Type.Function ([Type.Base "int"], Type.Base "int")) ],
        Type.Function ([Type.Base "int"], Type.Base "int"),
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
                )),
              [ Expression.Variable (Identifier.Name "x")
              ; Expression.IntLiteral 0 ]),
            Expression.IntLiteral 0,
            Expression.If (
              Expression.Call (
                Expression.Variable (
                  Identifier.BinOp (
                    BinaryOperation.Equal,
                    Type.Base "int",
                    Type.Base "int"
                  ) ),
                [ Expression.Variable (Identifier.Name "x")
                ; Expression.IntLiteral 1 ] ),
              Expression.IntLiteral 1,
              Expression.Call (
                Expression.Variable (
                  Identifier.BinOp (
                    BinaryOperation.Plus,
                    Type.Base "int",
                    Type.Base "int"
                  ) ),
                [ Expression.Call (
                    Expression.Variable (Identifier.Name "fib"),
                    [ Expression.Call (
                      Expression.Variable (
                        Identifier.BinOp (
                          BinaryOperation.Minus,
                          Type.Base "int",
                          Type.Base "int"
                        )),
                      [ Expression.Variable (Identifier.Name "x")
                      ; Expression.IntLiteral 1 ] ) ] )
                ; Expression.Call (
                    Expression.Variable (Identifier.Name "fib"),
                    [Expression.Call (
                      Expression.Variable (
                        Identifier.BinOp (
                          BinaryOperation.Minus,
                          Type.Base "int",
                          Type.Base "int"
                        ) ),
                      [ Expression.Variable (Identifier.Name "x")
                      ; Expression.IntLiteral 2 ] ) ] ) ] ) ) ) ) ) ] ),
    Expression.Call (
      Expression.Variable (Identifier.Name "fib"),
      [ Expression.IntLiteral 10 ] ) )