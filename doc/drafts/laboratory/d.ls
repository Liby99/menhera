let sum = x => y => x + y in
let max = x => y => if x > y then x else y in
let haha =
    let x = 3 in x + 3
in
sum (max 1 5) (max 3 9)
;;
