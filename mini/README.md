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
value will be interpreted as `int` (or `i32`). (`true` is `1`, `false` is `0`, objects as pointers and so on).

```
$ ./menhera --exec example/5.mhr
```
