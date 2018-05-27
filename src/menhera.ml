open Main
open Printf
;;

Printf.printf "%s\n" (Ast.to_string (Main.parse "let i = 3 in i + 4"));;
Printf.printf "%s\n" (Ast.to_string (Main.parse "i + 4 + 6"));;
Printf.printf "%s\n" (Ast.to_string (Main.parse "7 + 1 * 4"));;
Printf.printf "%s\n" (Ast.to_string (Main.parse "if true then 1 + 3 else false"));;
Printf.printf "%s\n" (Ast.to_string (Main.parse "let i = 2 in if i then true else false"));;
Printf.printf "%s\n" (Ast.to_string (Main.parse "let i = 2 in let j = 3 in i + j"));;
Printf.printf "%s\n" (Ast.to_string (Main.parse "let i = 2, j = 4 in i + j"));;
Printf.printf "%s\n" (Ast.to_string (Main.parse "let f = (a, b) => if a + b then a else b in f(3, 4)"));;
Printf.printf "%s\n" (Ast.to_string (Main.parse "((a, b) => a + b)(3, 4)"));;
Printf.printf "%s\n" (Ast.to_string (Main.parse "((a, b) => if a > b then a else b)(3, 4 + 6)"));;
Printf.printf "%s\n" (Ast.to_string (Main.parse "-((a, b) => if !(a > b) then a else b)(3, 4 + 6)"));;
Printf.printf "%s\n" (Ast.to_string (Main.parse "[[2, 4], 2, 3] ++ [4, 5, 6]"));;
Printf.printf "%s\n" (Ast.to_string (Main.parse "|[1, 2, 3] ++ [2, 3, 4]|"));;
Printf.printf "%s\n" (Ast.to_string (Main.parse "|[1, 2, 3]| + |[2, 3, 4]|"));;
Printf.printf "%s\n" (Ast.to_string (Main.parse "[3, 5, 7][2]"));;
Printf.printf "%s\n" (Ast.to_string (Main.parse "arr[2] + arr[3]"));;
Printf.printf "%s\n" (Ast.to_string (Main.parse "let max = ((x, y) => if x > y then x else y), sum = ((x, y) => x + y) in max(sum(input[0], input[1]), input[2])"));;
Printf.printf "%s\n" (Ast.to_string (Main.parse "let fib = (i) => fib(i - 1) + fib(i - 2) in fib(3)"));;
