let main = (x) => 10;
let add = (a, b) => a + b;
let max = (x, y) => x > y ? x : y;
let sum = (n) => n > 0 ? n + sum(n - 1) : 0;
let equal = (x, y) => x == y;
let and = (x, y) => x && y;
let or = (x, y) => x || y;
let bit_xor = (x, y) => x ^ y;
let bit_and = (x, y) => x & y;
let bit_or = (x, y) => x | y;
let range = (n) => n == 0 ? [] : (range(n - 1) :: n);
let call = (f, arg) => f(arg);
let calleg = (x) => call((y) => x + y, x);
let lt = (a, b) => a < b;
let gt = (a, b) => a > b;
let lte = (a, b) => a <= b;
let gte = (a, b) => a >= b;
let pln = (i) => print(i);
let arr = () => [1, 2, 3];
let ltest = () => let x = 3, y = 4 in x + y;
let sumarr = (arr) => match (arr) {
    ([]) => 0;
    (fst : rst) => fst + sumarr(rst);
};
let tupget = (tup, i) => tup[i];
let tuplen = (tup) => tup.length;
let typed_func = (int a, int b) : int => a + b

class List {
    
}
