e ::= x /* variables */
    | i /* integer */
    | true /* boolean */
    | false /* boolean */
    | (e1, e2, ...) /* tuple */
    | e1 + e2 /* addition */
    | e1 - e2 /* subtraction */
    | e1 * e2 /* multiplication */
    | e1 / e2 /* divide */
    | e1 < e2 /* less then */
    | e1 > e2 /* greater then */
    | e1 == e2 /* equals */
    | e1 <= e2 /* less then or equal to */
    | e1 >= e2 /* greater then or equal to */
    | e1 && e2 /* boolean and */
    | e1 || e2 /* boolean or */
    | !e /* boolean not */
    | let x = e1 in e2 /* let statement */
    | if e1 then e2 else e3 /* if statement */
    | (x, y) => e /* function definition */
    | f(x, y) /* function application */
