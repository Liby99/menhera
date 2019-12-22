open OUnit2
open Internal
open Eval

let eval_arith_1 test_ctxt =
  assert_equal
    (eval Std.stdctx
       (Expression.Call
          ( Expression.Variable
              (Identifier.BinOp
                 (BinaryOperation.Plus, Type.Base "int", Type.Base "int"))
          , [Expression.IntLiteral 1; Expression.IntLiteral 2] )))
    (Value.Integer 3)

let eval_sum_1 test_ctxt =
  assert_equal
    (eval Std.stdctx
       (Expression.Let
          ( Identifier.Name "sum"
          , Type.Function ([Type.Base "int"; Type.Base "int"], Type.Base "int")
          , Expression.Function
              ( [("x", Type.Base "int"); ("y", Type.Base "int")]
              , Type.Base "int"
              , Expression.Call
                  ( Expression.Variable
                      (Identifier.BinOp
                         ( BinaryOperation.Plus
                         , Type.Base "int"
                         , Type.Base "int" ))
                  , [ Expression.Variable (Identifier.Name "x")
                    ; Expression.Variable (Identifier.Name "y") ] ) )
          , Expression.Call
              ( Expression.Variable (Identifier.Name "sum")
              , [Expression.IntLiteral 4; Expression.IntLiteral 5] ) )))
    (Value.Integer 9)

let eval_rec_id_1 test_ctxt =
  assert_equal
    (eval Std.stdctx
       (Expression.Let
          ( Identifier.Name "f"
          , Type.Function ([Type.Base "int"], Type.Base "int")
          , Expression.Call
              ( Expression.Variable (Identifier.Name "rec")
              , [ Expression.Function
                    ( [ ( "f"
                        , Type.Function ([Type.Base "int"], Type.Base "int") )
                      ]
                    , Type.Function ([Type.Base "int"], Type.Base "int")
                    , Expression.Function
                        ( [("x", Type.Base "int")]
                        , Type.Base "int"
                        , Expression.If
                            ( Expression.Call
                                ( Expression.Variable
                                    (Identifier.BinOp
                                       ( BinaryOperation.Equal
                                       , Type.Base "int"
                                       , Type.Base "int" ))
                                , [ Expression.Variable (Identifier.Name "x")
                                  ; Expression.IntLiteral 0 ] )
                            , Expression.IntLiteral 0
                            , Expression.Call
                                ( Expression.Variable
                                    (Identifier.BinOp
                                       ( BinaryOperation.Plus
                                       , Type.Base "int"
                                       , Type.Base "int" ))
                                , [ Expression.IntLiteral 1
                                  ; Expression.Call
                                      ( Expression.Variable
                                          (Identifier.Name "f")
                                      , [ Expression.Call
                                            ( Expression.Variable
                                                (Identifier.BinOp
                                                   ( BinaryOperation.Minus
                                                   , Type.Base "int"
                                                   , Type.Base "int" ))
                                            , [ Expression.Variable
                                                  (Identifier.Name "x")
                                              ; Expression.IntLiteral 1 ] ) ]
                                      ) ] ) ) ) ) ] )
          , Expression.Call
              ( Expression.Variable (Identifier.Name "f")
              , [Expression.IntLiteral 10] ) )))
    (Value.Integer 10)

let eval_fib_1 test_ctxt =
  assert_equal
    (eval Std.stdctx
       (Expression.Let
          ( Identifier.Name "fib"
          , Type.Function ([Type.Base "int"], Type.Base "int")
          , Expression.Call
              ( Expression.Variable (Identifier.Name "rec")
              , [ Expression.Function
                    ( [ ( "fib"
                        , Type.Function ([Type.Base "int"], Type.Base "int") )
                      ]
                    , Type.Function ([Type.Base "int"], Type.Base "int")
                    , Expression.Function
                        ( [("x", Type.Base "int")]
                        , Type.Base "int"
                        , Expression.If
                            ( Expression.Call
                                ( Expression.Variable
                                    (Identifier.BinOp
                                       ( BinaryOperation.Equal
                                       , Type.Base "int"
                                       , Type.Base "int" ))
                                , [ Expression.Variable (Identifier.Name "x")
                                  ; Expression.IntLiteral 0 ] )
                            , Expression.IntLiteral 0
                            , Expression.If
                                ( Expression.Call
                                    ( Expression.Variable
                                        (Identifier.BinOp
                                           ( BinaryOperation.Equal
                                           , Type.Base "int"
                                           , Type.Base "int" ))
                                    , [ Expression.Variable
                                          (Identifier.Name "x")
                                      ; Expression.IntLiteral 1 ] )
                                , Expression.IntLiteral 1
                                , Expression.Call
                                    ( Expression.Variable
                                        (Identifier.BinOp
                                           ( BinaryOperation.Plus
                                           , Type.Base "int"
                                           , Type.Base "int" ))
                                    , [ Expression.Call
                                          ( Expression.Variable
                                              (Identifier.Name "fib")
                                          , [ Expression.Call
                                                ( Expression.Variable
                                                    (Identifier.BinOp
                                                       ( BinaryOperation.Minus
                                                       , Type.Base "int"
                                                       , Type.Base "int" ))
                                                , [ Expression.Variable
                                                      (Identifier.Name "x")
                                                  ; Expression.IntLiteral 1 ]
                                                ) ] )
                                      ; Expression.Call
                                          ( Expression.Variable
                                              (Identifier.Name "fib")
                                          , [ Expression.Call
                                                ( Expression.Variable
                                                    (Identifier.BinOp
                                                       ( BinaryOperation.Minus
                                                       , Type.Base "int"
                                                       , Type.Base "int" ))
                                                , [ Expression.Variable
                                                      (Identifier.Name "x")
                                                  ; Expression.IntLiteral 2 ]
                                                ) ] ) ] ) ) ) ) ) ] )
          , Expression.Call
              ( Expression.Variable (Identifier.Name "fib")
              , [Expression.IntLiteral 5] ) )))
    (Value.Integer 5)

let tests =
  [ "eval_arith_1" >:: eval_arith_1
  ; "eval_sum_1" >:: eval_sum_1
  ; "eval_rec_id_1" >:: eval_rec_id_1
  ; "eval_fib_1" >:: eval_fib_1 ]
