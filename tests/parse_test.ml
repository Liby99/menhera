open OUnit2
open Parsing
open Grammar

let parse_arith_1 _ = assert_equal (parse "1 + 2") (BinOp (Plus, Int 1, Int 2))

let parse_arith_2 _ =
  assert_equal (parse "1 + 2 * 3")
    (BinOp (Plus, Int 1, BinOp (Multiply, Int 2, Int 3)))

let parse_arith_3 _ =
  assert_equal (parse "(1 + 2) * 3")
    (BinOp (Multiply, BinOp (Plus, Int 1, Int 2), Int 3))

let parse_bool_1 _ =
  assert_equal (parse "true && 1 == 2")
    (BinOp (And, Bool true, BinOp (Equal, Int 1, Int 2)))

let parse_if_1 _ =
  assert_equal (parse "if true then 3 else 4") (If (Bool true, Int 3, Int 4))

let parse_if_2 _ =
  assert_equal
    (parse "if if true then false else true then 3 else 4")
    (If (If (Bool true, Bool false, Bool true), Int 3, Int 4))

let parse_let_1 _ =
  assert_equal (parse "let a = 3 in a") (Let (Id "a", None, Int 3, Var "a"))

let parse_let_2 _ =
  assert_equal
    (parse "let a = 3 in let b = 4 in a + b")
    (Let
       ( Id "a"
       , None
       , Int 3
       , Let (Id "b", None, Int 4, BinOp (Plus, Var "a", Var "b")) ))

let parse_let_3 _ =
  assert_equal
    (parse "let a : int = 3 in let b : int = 4 in a + b")
    (Let
       ( Id "a"
       , Some (TyId "int")
       , Int 3
       , Let (Id "b", Some (TyId "int"), Int 4, BinOp (Plus, Var "a", Var "b"))
       ))

let tests =
  [ "parse_arith_1" >:: parse_arith_1
  ; "parse_arith_2" >:: parse_arith_2
  ; "parse_arith_3" >:: parse_arith_3
  ; "parse_bool_1" >:: parse_bool_1
  ; "parse_if_1" >:: parse_if_1
  ; "parse_if_2" >:: parse_if_2
  ; "parse_let_1" >:: parse_let_1
  ; "parse_let_2" >:: parse_let_2
  ; "parse_let_3" >:: parse_let_3 ]
