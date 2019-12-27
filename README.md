# Menhera Lang

A toy language & interpreter mocking the design of OCaml and JavaScript, statically typed with inference.

```
let sum = (a, b) => a + b in
sum(3, 5)
```

## Syntax

Integer, boolean, let and if:

```
let a: bool = true in
let b: int = 3 in
if b == 4 then a
else false
```

If you don't want to write the type explicitly, the above program will become

```
let a = true in
let b = 3 in
if b == 4 then a
else false
```

Function and function calls:

```
let sum = (a, b) => a + b in
sum(3, 5)
```

You can of course add explicit type definition

```
let sum : (int, int) -> int =
  (a : int, b : int) : int =>
    a + b
in
sum(3, 5)
```

## How to build & run

Clone the repository. First please make sure you installed `ocaml` >= 4.08, `ocamlbuild`, `menhir` and `ppx_derive`. Then you can simply do

```
$ make
```

To run one of our examples, please

```
$ ./menhera -show-result examples/function/sum.mhr
```

The argument `-show-result` means that it will print out the raw format of the result value after running this file.

## How to test

```
$ make test
$ ./test
```