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
    ("ls_1", "main { a[b] }", Program([MainSect(BinOp(ListGet, Id("a"), Id("b")))]));
    ("ls_2", "main { a[b][c] }", Program([MainSect(BinOp(ListGet, BinOp(ListGet, Id("a"), Id("b")), Id("c")))]));
    ("ls_3", "main { a[b[c]] }", Program([MainSect(BinOp(ListGet, Id("a"), BinOp(ListGet, Id("b"), Id("c"))))]));
    ("arr_1", "main { let a : [int] = [1, 2, 3] in a[1] }", Program([MainSect(Let([Binding(VarWithType("a", ListTypeSig(UnitTypeSig("int"))), List([Int(1); Int(2); Int(3)]))], BinOp(ListGet, Id("a"), Int(1))))]));
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
    ("match_1", "main { match (1) { 1 => true, _ => false } }", Program([MainSect(Match(Int(1), [(PatInt(1), Bool(true)); (PatWildCard, Bool(false))]))]));
    ("func_1", "main { ((a) => a + 1)(2) }", Program([MainSect(App(Function([Var("a")], None, BinOp(Plus, Id("a"), Int(1))), [Int(2)]))]));
    ("mod_1", "import { math } main { math::pi }", Program([ImportSect([Import("math")]); MainSect(ModuleId("math", "pi"))]));
    ("mod_2", "import { math } main { math::cos(math::pi * 3 / 2) }", Program([ImportSect([Import("math")]); MainSect(App(ModuleId("math", "cos"), [BinOp(Divide, BinOp(Times, ModuleId("math", "pi"), Int(3)), Int(2))]))]));
    ("comment_1", "main { /* Ahahahahaha */ a + /* hahahaha */ b }", Program([MainSect(BinOp(Plus, Id("a"), Id("b")))]));
    ("comment_2", "main { /* Ahahahahaha */ a + /* hahahaha */ b // hahahaha \n + c }", Program([MainSect(BinOp(Plus, BinOp(Plus, Id("a"), Id("b")), Id("c")))]));
    ("compound", "main {\n\
        /* This is a great comment */\n\
        let sum = (x, y) => x + y in\n\
        let pi = 3.1415926 in\n\
        let f = (args) => // This is an inline comment\n\
            let mi1 = int::parse(args[0]),\n\
                mi2 = int::parse(args[1])\n\
            in match (mi1) {\n\
                /* I need\n\
                   multiline\n\
                   comment\n\
                   as well */\n\
                Some(i1) => match (mi2) {\n\
                    Some(i2) => sum(i1, i2),\n\
                    None => -1\n\
                },\n\
                None => -1\n\
            }\n\
        in f\n\
    }", Program([MainSect(
    Let([Binding(Var("sum"), Function([Var("x"); Var("y")], None, BinOp(Plus, Id("x"), Id("y"))))],
        Let([Binding(Var("pi"), Float(3.1415926))],
            Let([Binding(Var("f"), Function([Var("args")], None,
                Let([
                    Binding(Var("mi1"), App(ModuleId("int", "parse"), [BinOp(ListGet, Id("args"), Int(0))]));
                    Binding(Var("mi2"), App(ModuleId("int", "parse"), [BinOp(ListGet, Id("args"), Int(1))]))
                ], Match(Id("mi1"), [
                    (PatApp(PatId("Some"), [PatId("i1")]), Match(Id("mi2"), [
                        (PatApp(PatId("Some"), [PatId("i2")]), App(Id("sum"), [Id("i1"); Id("i2")]));
                        (PatId("None"), Int(-1))
                    ]));
                    (PatId("None"), Int(-1))
                ]))
            ))], Id("f"))
        )
    ))]))
]

let rec test_parsing_prog (name : string) (input : string) (expected : prog) : bool =
    try
        let result = parse_string input in
        if result = expected
            then true
            else (printf "Mismatch when testing %s: \n -- expect: %s\n -- actual: %s\n" name (string_of_prog expected) (string_of_prog result); false)
    with
        | ParseError(e) -> (printf "Exception thrown when testing %s: \n  %s\n" name e; false)

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
