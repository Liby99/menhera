# Menhera Language

Menhera Language implemented using TypeScript.

Language snippet:

```
let sum = (a) => (b) => a + b in
let res = sum(3)(5) in
res + 8
```

## Building

```
$ make
```

## Run

```
$ ./menhera sample/sum.mhr > sum.ll
$ lli sum.ll
```