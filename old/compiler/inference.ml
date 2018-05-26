type wc =
    | WildCard of int

type itype =
    | IFunction of itype * itype
    | INumber
    | IBoolean
    | ICharacter
    | IArray of itype
    | ITuple of itype * itype
    | ITao of wc

let max_type = IFunction(INumber, IFunction(INumber, INumber))

let if_type i = IFunction(IBoolean, ITao(i))

let inference (ls : (itype * itype) list) : itype =
    
    
let unify (a : (wc * itype)) (b : (wc * itype)) : (itype * itype) option =
    
