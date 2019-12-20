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
    ; Expression.IntLiteral 2 ] )

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

let main _ =
  let result = eval stdctx fib_example in
  match result with
  | Value.Integer i ->
      Printf.printf "Arith result %d\n" i ;
      ()
  | _ -> ()

;;

main "example/arith.mhr"