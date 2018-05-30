open Ast
open Printf

let parse s f =
    let lexbuf = Lexing.from_string s in
    let ast = f Lexer.read lexbuf in
    ast
let parse_expr s = parse Parser.expr s
let parse_prog s = parse Parser.prog s
;;

Printf.printf "%s\n" (Ast.to_string (parse_expr "let i = 3 in i + 4"));;
Printf.printf "%s\n" (Ast.to_string (parse_expr "i + 4 + 6"));;
Printf.printf "%s\n" (Ast.to_string (parse_expr "7 + 1 * 4"));;
Printf.printf "%s\n" (Ast.to_string (parse_expr "if true then 1 + 3 else false"));;
Printf.printf "%s\n" (Ast.to_string (parse_expr "let i = 2 in if i then true else false"));;
Printf.printf "%s\n" (Ast.to_string (parse_expr "let i = 2 in let j = 3 in i + j"));;
Printf.printf "%s\n" (Ast.to_string (parse_expr "let i = 2, j = 4 in i + j"));;
Printf.printf "%s\n" (Ast.to_string (parse_expr "let f = (a, b) => if a + b then a else b in f(3, 4)"));;
Printf.printf "%s\n" (Ast.to_string (parse_expr "((a, b) => a + b)(3, 4)"));;
Printf.printf "%s\n" (Ast.to_string (parse_expr "((a, b) => if a > b then a else b)(3, 4 + 6)"));;
Printf.printf "%s\n" (Ast.to_string (parse_expr "-((a, b) => if !(a > b) then a else b)(3, 4 + 6)"));;
Printf.printf "%s\n" (Ast.to_string (parse_expr "[[2, 4], 2, 3] + [4, 5, 6]"));;
Printf.printf "%s\n" (Ast.to_string (parse_expr "|[1, 2, 3] + [2, 3, 4]|"));;
Printf.printf "%s\n" (Ast.to_string (parse_expr "|[1, 2, 3]| + |[2, 3, 4]|"));;
Printf.printf "%s\n" (Ast.to_string (parse_expr "[3, 5, 7][2]"));;
Printf.printf "%s\n" (Ast.to_string (parse_expr "arr[2] + arr[3]"));;
Printf.printf "%s\n" (Ast.to_string (parse_expr "let max = ((x, y) => if x > y then x else y), sum = ((x, y) => x + y) in max(sum(input[0], input[1]), input[2])"));;
Printf.printf "%s\n" (Ast.to_string (parse_expr "let fib = (i) => fib(i - 1) + fib(i - 2) in fib(3)"));;
Printf.printf "%s\n" (Ast.to_string (parse_expr "f()"));;
Printf.printf "%s\n" (Ast.to_string (parse_expr "f(\"a\")"));;
Printf.printf "%s\n" (Ast.to_string (parse_expr "let \
        linked_list = () => [],\
        push = (ls, e) => [e, ls],\
        pop = (ls) => ls[1],\
        peek = (ls) => ls[0],\
        length = (ls) => if ls == [] then 0 else 1 + length(ls[1]),\
        get = (ls, i) => if i == 0 then ls[0] else get(ls[1], i - 1),\
        str = (ls) => let f = (ls) => if ls == [] then \"\" else if ls[1] == [] then ls[0] else ls[0] + \", \" + str(ls[1]) in \"[\" + f(ls) + \"]\"\
    in linked_list()"));;
