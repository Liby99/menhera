# Menhera Language

Menhera Language is a functional programming language which is statically typed with type inference,
pattern matching and with functions as first class variables.

Example:

```
import { maybe }

main {
    let sum = (x, y) => x + y in
    let pi = 3.1415926 in
    let main = (args) =>
        let mi1 = int::parse(args[0]),
            mi2 = int::parse(args[1])
        in match (mi1) {
            Some(i1) => match (mi2) {
                Some(i2) => sum(i1, i2),
                None => -1
            },
            None => -1
        }
    in main
}
```

## Usage

``` bash
$ make
$ ./menhera MY_PROG.mhr MY_PROG
$ ./MY_PROG
```
