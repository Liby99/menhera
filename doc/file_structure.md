# File Structure of Menhera

A `.mhr` file consists of the following 4 elements:

### `import` section

The import should happen before every other section, and will have syntax like:

```
import {
    fs,
    string as str,
    { println, print } from console
}
```

In the above example, `fs` module is imported as is, and the usage inside later program will be
`fs::read_file("a.txt")`. Meanwhile `string` is imported with an alias of `str`, so instead of
doing `string::replace(...)` we should have `str::replace(...)`. Nevertheless, when importing
`console` we only imported its function `println` and `print`. So all the other members in
`console` is not available in this file and when using `println` and `print` we don't need the
namespace specification like `console::println(...)`.

There could be only one `import` section inside a single `.mhr` file.

### `type` Section

A type definition has syntax like:

```
type linked_list<T> {
    Tail,
    Node(T, linked_list<T>)
}
```

We can define a type called `NAME` with generic wildcards specified in a `<` `>`. Within the
curly braces we can specify constructors and its parameters (in type) separated by `,`. Of
course there could also be no generic type here.

Inside a `.mhr` file there could be multiple `type` definition and once this file is imported by
another file, all the type definitions will be imported as well.

All the type definitions are supposed to be come before the module section and main section.

### `module` Section
    
A module has syntax

```
module {
    pi = 3.1415926,
    max = (x, y) => x > y ? x : y,
    ...
}
```

Inside a `.mhr` file there could only be at most *ONE*
`module` section. When this file is imported, then the whole module will be exposed to the
importer file.
    
### `main` Section
    
A main definition has syntax `main (args) { ... }`. This is supposed to be the entry point of whole
program. Inside main section we can use the modules we imported using `NAMESPACE::VAR`, as well
as the method and constants in `module` section defined within the same file without using
namespace specification.

```
main (args) {
    let a = 3 in a + 3
}
```

When the module is imported, then the `main` section will have no use. When we do

```
$ menhera FILE.mhr
```

only the main section in `FILE.mhr` will be compiled as the entry point of the whole program.

### Real example

```
import {
    console
}

type point {
    Cartesian(float, float),
    Polar(float, float)
}

type shape {
    Square(float),
    Circle(point, float)
}

module {
    `$` = (s) => match s {
        Square(s) => "Square with side length " + $s,
        Circle(p, r) => "Circle with center " + $p + " and radius " + $r
    },
    `$` = (p) => match p {
        Cartesian(x, y) => "C(" + $x + "," + $y + ")",
        Polar(a, r) => "P(" + $a + ", " + $r + ")"
    }
}

main (args) {
    let c = Circle(Cartesian(1, 2), 3) in
    console::println($c)
}
```
