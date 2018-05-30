open Grammer;;
open AstString;;

let s1 = parse_type_def "type linked_list<T> { Tail, Node(T, linked_list<T>) }";;
let s2 = parse_type_def "type maybe<T> { None, Some(T) }";;
Printf.printf "%s\n" (string_of_type_def s1);;
Printf.printf "%s\n" (string_of_type_def s2);;
