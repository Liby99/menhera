(let (
    (sum (fun x (fun y (+ x y))))
    (max (fun x (fun y (if (> x y) x y))))
) (sum (max 1 5) (max 3 9)))

<<<<<<<

let sum = x => y => x + y,
    max = x => y =>
        if x > y
            then x
            else y
in
sum (max 1 5) (max 3 9)

-------

(let (
    (t (tuple 3 5))
    (rev (fun t (tuple (tuple-get t 1) (tuple-get t 0))))
) (rev t))

<<<<<<<

let t = (3, 5),
    rev = t => (t[1], t[0])
in
rev t

-------
