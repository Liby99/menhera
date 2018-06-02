open Ast
open AstString
open Parsing
open Printf

let parser_tests = [
    ("type_1", "type binop { Plus, Minus }", Program([TypeSect(TypeDef(UnitTypeDefSig("binop"), [UnitCtor("Plus"); UnitCtor("Minus")]))]));
    ("type_2", "type maybe<T> { None, Some(T) }", Program([TypeSect(TypeDef(GenTypeDefSig("maybe", ["T"]), [UnitCtor("None"); CompCtor("Some", [UnitTypeSig(Id("T"))])]))]));
    ("type_3", "type linked_list<T> { Tail, Node(T, linked_list<T>) }", Program([TypeSect(TypeDef(GenTypeDefSig("linked_list", ["T"]), [UnitCtor("Tail"); CompCtor("Node", [UnitTypeSig(Id("T")); GenTypeSig(Id("linked_list"), [UnitTypeSig(Id("T"))])])]))]));
    ("type_multi", "type binop { Plus, Minus } type unaop { Not, Neg }", Program([TypeSect(TypeDef(UnitTypeDefSig("binop"), [UnitCtor("Plus"); UnitCtor("Minus")])); TypeSect(TypeDef(UnitTypeDefSig("unaop"), [UnitCtor("Not"); UnitCtor("Neg")]))]));
    ("arith_1", "main { 3 - 4 + 1 }", Program([MainSect(EBinOp(Plus, EBinOp(Minus, EInt(3), EInt(4)), EInt(1)))]));
    ("arith_2", "main { 3 - 4 * 1 }", Program([MainSect(EBinOp(Minus, EInt(3), EBinOp(Times, EInt(4), EInt(1))))]));
    ("arith_3", "main { (3 - 4) * 1 }", Program([MainSect(EBinOp(Times, EBinOp(Minus, EInt(3), EInt(4)), EInt(1)))]));
    ("arith_4", "main { (3 - 4) / 1 }", Program([MainSect(EBinOp(Divide, EBinOp(Minus, EInt(3), EInt(4)), EInt(1)))]));
    ("arith_5", "main { 1 + 2 + 3 }", Program([MainSect(EBinOp(Plus, EBinOp(Plus, EInt(1), EInt(2)), EInt(3)))]));
    ("arith_6", "main { 1 + -a }", Program([MainSect(EBinOp(Plus, EInt(1), EUnaOp(Neg, EId(Id("a")))))]));
    ("arith_7", "main { -(1 + 3) }", Program([MainSect(EUnaOp(Neg, EBinOp(Plus, EInt(1), EInt(3))))]));
    ("ls_1", "main { a[b] }", Program([MainSect(EBinOp(ListGet, EId(Id("a")), EId(Id("b"))))]));
    ("ls_2", "main { a[b][c] }", Program([MainSect(EBinOp(ListGet, EBinOp(ListGet, EId(Id("a")), EId(Id("b"))), EId(Id("c"))))]));
    ("ls_3", "main { a[b[c]] }", Program([MainSect(EBinOp(ListGet, EId(Id("a")), EBinOp(ListGet, EId(Id("b")), EId(Id("c")))))]));
    ("arr_1", "main { let a : [int] = [1, 2, 3] in a[1] }", Program([MainSect(ELet([(VarWithType("a", ListTypeSig(UnitTypeSig(Id("int")))), EList([EInt(1); EInt(2); EInt(3)]))], EBinOp(ListGet, EId(Id("a")), EInt(1))))]));
    ("una_1", "main { !true }", Program([MainSect(EUnaOp(Not, EBool(true)))]));
    ("una_2", "main { !!true }", Program([MainSect(EUnaOp(Not, EUnaOp(Not, EBool(true))))]));
    ("bool_1", "main { !true && false  }", Program([MainSect(EBinOp(And, EUnaOp(Not, EBool(true)), EBool(false)))]));
    ("bool_2", "main { true && false || true }", Program([MainSect(EBinOp(Or, EBinOp(And, EBool(true), EBool(false)), EBool(true)))]));
    ("let_1", "main { let a = 3 in a + 1 }", Program([MainSect(ELet([(Var("a"), EInt(3))], EBinOp(Plus, EId(Id("a")), EInt(1))))]));
    ("let_2", "main { let a : int = 3 in a + 1 }", Program([MainSect(ELet([(VarWithType("a", UnitTypeSig(Id("int"))), EInt(3))], EBinOp(Plus, EId(Id("a")), EInt(1))))]));
    ("let_3", "main { let a = 3, b = 4 in a + b }", Program([MainSect(ELet([(Var("a"), EInt(3)); (Var("b"), EInt(4))], EBinOp(Plus, EId(Id("a")), EId(Id("b")))))]));
    ("let_4", "main { let a = let b = 4 in b in a }", Program([MainSect(ELet([(Var("a"), ELet([(Var("b"), EInt(4))], EId(Id("b"))))], EId(Id("a"))))]));
    ("if_1", "main { true ? 1 : 2 }", Program([MainSect(EIf(EBool(true), EInt(1), EInt(2)))]));
    ("if_2", "main { if true then 1 else 2 }", Program([MainSect(EIf(EBool(true), EInt(1), EInt(2)))]));
    ("if_3", "main { a > b ? a > c ? a : c : b > c ? b : c }", Program([MainSect(
        EIf(EBinOp(Greater, EId(Id("a")), EId(Id("b"))),
            EIf(EBinOp(Greater, EId(Id("a")), EId(Id("c"))), EId(Id("a")), EId(Id("c"))),
            EIf(EBinOp(Greater, EId(Id("b")), EId(Id("c"))), EId(Id("b")), EId(Id("c")))
        )
    )]));
    ("match_1", "main { match (1) { 1 => true, _ => false } }", Program([MainSect(EMatch(EInt(1), [(PInt(1), EBool(true)); (PWildCard, EBool(false))]))]));
    ("func_1", "main { ((a) => a + 1)(2) }", Program([MainSect(EApp(EFunction([Var("a")], None, EBinOp(Plus, EId(Id("a")), EInt(1))), [EInt(2)]))]));
    ("mod_1", "import { math } main { math::pi }", Program([ImportSect([Import("math")]); MainSect(EId(ModuleId("math", "pi")))]));
    ("mod_2", "import { math } main { math::cos(math::pi * 3 / 2) }", Program([ImportSect([Import("math")]); MainSect(EApp(EId(ModuleId("math", "cos")), [EBinOp(Divide, EBinOp(Times, EId(ModuleId("math", "pi")), EInt(3)), EInt(2))]))]));
    ("comment_1", "main { /* Ahahahahaha */ a + /* hahahaha */ b }", Program([MainSect(EBinOp(Plus, EId(Id("a")), EId(Id("b"))))]));
    ("comment_2", "main { /* Ahahahahaha */ a + /* hahahaha */ b // hahahaha \n + c }", Program([MainSect(EBinOp(Plus, EBinOp(Plus, EId(Id("a")), EId(Id("b"))), EId(Id("c"))))]));
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
