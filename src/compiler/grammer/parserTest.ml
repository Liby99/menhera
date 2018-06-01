open Ast
open AstString
open Parsing
open Printf

let parser_tests = [
    ("type_1", "type binop { Plus, Minus }", Program([TypeSect(TypeDef(UnitTypeDefSig("binop"), [UnitCtor("Plus"); UnitCtor("Minus")]))]));
    ("type_2", "type maybe<T> { None, Some(T) }", Program([TypeSect(TypeDef(GenTypeDefSig("maybe", ["T"]), [UnitCtor("None"); CompCtor("Some", [UnitTypeSig("T")])]))]));
    ("type_3", "type linked_list<T> { Tail, Node(T, linked_list<T>) }", Program([TypeSect(TypeDef(GenTypeDefSig("linked_list", ["T"]), [UnitCtor("Tail"); CompCtor("Node", [UnitTypeSig("T"); GenTypeSig("linked_list", [UnitTypeSig("T")])])]))]));
    ("type_multi", "type binop { Plus, Minus } type unaop { Not, Neg }", Program([TypeSect(TypeDef(UnitTypeDefSig("binop"), [UnitCtor("Plus"); UnitCtor("Minus")])); TypeSect(TypeDef(UnitTypeDefSig("unaop"), [UnitCtor("Not"); UnitCtor("Neg")]))]));
    ("arith_1", "main { 3 - 4 + 1 }", Program([MainSect(BinOp(Plus, BinOp(Minus, Int(3), Int(4)), Int(1)))]));
    ("arith_2", "main { 3 - 4 * 1 }", Program([MainSect(BinOp(Minus, Int(3), BinOp(Times, Int(4), Int(1))))]));
    ("arith_3", "main { (3 - 4) * 1 }", Program([MainSect(BinOp(Times, BinOp(Minus, Int(3), Int(4)), Int(1)))]));
    ("arith_4", "main { (3 - 4) / 1 }", Program([MainSect(BinOp(Divide, BinOp(Minus, Int(3), Int(4)), Int(1)))]));
    ("arith_5", "main { 1 + 2 + 3 }", Program([MainSect(BinOp(Plus, BinOp(Plus, Int(1), Int(2)), Int(3)))]));
    ("arith_6", "main { 1 + -a }", Program([MainSect(BinOp(Plus, Int(1), UnaOp(Neg, Id("a"))))]));
    ("arith_7", "main { -(1 + 3) }", Program([MainSect(UnaOp(Neg, BinOp(Plus, Int(1), Int(3))))]));
    ("una_1", "main { !true }", Program([MainSect(UnaOp(Not, Bool(true)))]));
    ("una_2", "main { !!true }", Program([MainSect(UnaOp(Not, UnaOp(Not, Bool(true))))]));
    ("bool_1", "main { !true && false  }", Program([MainSect(BinOp(And, UnaOp(Not, Bool(true)), Bool(false)))]));
    ("bool_2", "main { true && false || true }", Program([MainSect(BinOp(Or, BinOp(And, Bool(true), Bool(false)), Bool(true)))]));
    ("let_1", "main { let a = 3 in a + 1 }", Program([MainSect(Let([Binding(Var("a"), Int(3))], BinOp(Plus, Id("a"), Int(1))))]));
    ("let_2", "main { let a : int = 3 in a + 1 }", Program([MainSect(Let([Binding(VarWithType("a", UnitTypeSig("int")), Int(3))], BinOp(Plus, Id("a"), Int(1))))]));
    ("let_3", "main { let a = 3, b = 4 in a + b }", Program([MainSect(Let([Binding(Var("a"), Int(3)); Binding(Var("b"), Int(4))], BinOp(Plus, Id("a"), Id("b"))))]));
    ("let_4", "main { let a = let b = 4 in b in a }", Program([MainSect(Let([Binding(Var("a"), Let([Binding(Var("b"), Int(4))], Id("b")))], Id("a")))]));
    ("if_1", "main { true ? 1 : 2 }", Program([MainSect(If(Bool(true), Int(1), Int(2)))]));
    ("if_2", "main { if true then 1 else 2 }", Program([MainSect(If(Bool(true), Int(1), Int(2)))]));
    ("if_3", "main { a > b ? a > c ? a : c : b > c ? b : c }", Program([MainSect(If(BinOp(Greater, Id("a"), Id("b")), If(BinOp(Greater, Id("a"), Id("c")), Id("a"), Id("c")), If(BinOp(Greater, Id("b"), Id("c")), Id("b"), Id("c"))))]));
    ("func_1", "main { ((a) => a + 1)(2) }", Program([MainSect(App(Function([Var("a")], None, BinOp(Plus, Id("a"), Int(1))), [Int(2)]))]));
]

let rec test_parsing_prog (name : string) (input : string) (expected : prog) : bool =
    try
        let result = parse input in
        if result = expected
            then true
            else (printf "Error when testing %s: \n -- expect: %s\n -- actual: %s\n" name (string_of_prog expected) (string_of_prog result); false)
    with _ -> (printf "Exception thrown when testing %s: \n -- expect: %s\n" name (string_of_prog expected); false )

and test_parsing_progs (tests : (string * string * prog) list) (passed : int) (total : int) =
    match tests with
        | [] -> (passed, total)
        | (n, i, e) :: rst ->
            let res = test_parsing_prog n i e in
            test_parsing_progs rst (if res then passed + 1 else passed) (total + 1)

and test_parsing () =
    printf "-- Testing Parser Start --\n";
    let (passed, total) = test_parsing_progs parser_tests 0 0 in
    printf "-- Total %d, Passed %d --\n" total passed;
