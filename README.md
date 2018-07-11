# Menhera Language

Menhera Language is a functional programming language which is statically typed with type inference,
pattern matching and with functions as first class variables.

Currently Liby is still experimenting with LLVM and gradually implementing new functionalities.

Example (Expected):

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

## Build

The documented build process is on MacOS. There are lots of dependencies to be installed

System-wise:

```
$ brew install pkg-config
$ brew install llvm
```

Opam-wise (Before running this, make sure you have installed Ocaml and Opam):

```
$ opam install menhir
$ opam install ctypes-foreign
$ opam install llvm
```

And then start the make process

```
$ make
```

## Usage

### Help Message

```
$ ./menhera --help
```

### Get The Abstract Syntax Tree

```
$ ./menhera --parse example/2.mhr
```

### Get the LLVM Intermediate Representation (IR)

```
$ ./menhera --llvm example/3.mhr
```

If you want to dump the `.ll` file and then go with the traditional ll pipeline you can use

```
$ ./menhera --llvm example/4.mhr > my_mhr.ll
$ llc my_mhr.ll
$ clang my_mhr.s
$ ./a.out
```

### Execute the Program

Note that there's no explicit input to the program. This is run inside a function called `main`. Also all the return
value need to be interpreted as `int` (or `i32`). A return value like `bool` (`true` or `false`) will not work because
they have different type.

```
$ ./menhera --exec example/5.mhr
```
