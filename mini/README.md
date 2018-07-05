# Mini Menhera

This is the current version of Menhera that can be compiled from raw `.mhr` file to execution through LLVM pipeline.
I am building this Mini version functionality by functionality and am continue going to approach designed syntax and
semantics gradually.

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
$ ./mini_menhera
```

or

```
$ ./mini_menhera -h
```

or

```
$ ./mini_menhera --help
```

### Get The Abstract Syntax Tree

```
$ ./mini_menhera -p ../example/mini/7.mhr
```

or

```
$ ./mini_menhera --parse ../example/mini/7.mhr
```

### Get the LLVM Intermediate Representation (IR)

```
$ ./mini_menhera -l ../example/mini/7.mhr
```

or

```
$ ./mini_menhera --llvm ../example/mini/7.mhr
```

### Execute the Program

Note that there's no explicit input to the program. This is run inside a function called `main`. Also all the return
value will be interpreted as `int` (or `i32`). (`true` is `1`, `false` is `0`, objects as pointers and so on).

```
$ ./mini_menhera -e ../example/mini/7.mhr
```

or

```
$ ./mini_menhera --exec ../example/mini/7.mhr
```
