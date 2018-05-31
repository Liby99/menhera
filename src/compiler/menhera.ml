open Grammer;;
open AstString;;

let s1 = parse "type linked_list<T> { Tail, Node(T, linked_list<T>) }";;
let s2 = parse "type maybe<T> { None, Some(T) }";;
let s3 = parse "import { maybe, linked_list as ll } type a<b> { Ctor, Ctor2 }";;
Printf.printf "%s\n" (string_of_prog s1);;
Printf.printf "%s\n" (string_of_prog s2);;
Printf.printf "%s\n" (string_of_prog s3);;
