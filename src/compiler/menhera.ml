open Grammer;;
open AstString;;

Printf.printf "%s\n" (string_of_prog (parse "type linked_list<T> { Tail, Node(T, linked_list<T>) }"));;
Printf.printf "%s\n" (string_of_prog (parse "type maybe<T> { None, Some(T) }"));;
Printf.printf "%s\n" (string_of_prog (parse "import { maybe, linked_list as ll } type a<b> { Ctor, Ctor2 }"));;
Printf.printf "%s\n" (string_of_prog (parse "import { maybe } main { 3 + 4 }"));;
