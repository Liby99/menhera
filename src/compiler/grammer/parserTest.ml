open Ast
open AstString
open Parsing
open Printf

let parser_tests = [
    ("arith_1", "main { 3 - 4 + 1 }", Program([MainSect(BinOp(Plus, BinOp(Minus, Int(3), Int(4)), Int(1)))]));
    ("func_1", "main { ((a) => a + 1)(2) }", Program([MainSect(App(Function([Var("a")], None, BinOp(Plus, Id("a"), Int(1))), [Int(2)]))]))
]

let rec test_parsing_prog (name : string) (input : string) (expected : prog) : bool =
    let result = parse input in
    if result = expected
        then true
        else (
            Printf.printf "Error when testing %s: \n -> expect: %s\n -> but got: %s\n" name (string_of_prog expected) (string_of_prog result);
            failwith "Test Failed"
        )

and test_parsing_progs (tests : (string * string * prog) list) =
    match tests with
        | [] -> ()
        | (n, i, e) :: rst ->
            let _ = test_parsing_prog n i e in
            test_parsing_progs rst

and test_parsing () = test_parsing_progs parser_tests
