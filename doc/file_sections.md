# File Sections of Menhera

A `.mhr` file consists of the following 4 sections, `import`, `type`, `module` and `main`,
each defining different usage of the file. Here's an example defining all four sections
and can have a good demonstration of what these sections are.

``` mhr
/* linked_list.mhr */

import { maybe }

type linked_list<T> { Tail, Node(T, linked_list<T>) }

module {
    new = () : linked_list<T> => Tail,
    get = (ls : linked_list<T>, i : int) : T => match (ls) {
        Tail => None,
        Node(d, l) => i == 0 ? d : get(l, i - 1)
    },
    push = (ls : linked_list<T>, d : T) : linked_list<T> => Node(d, ls)
}

main {
    (argv : [string]) : int =>
        let ll : linked_list<int> = push(push(push(new(), 1), 2), 3) in
        match (get(ll, 1)) {
            Some(n) => n
            None => -1
        }
}
```

Inside this example we import the `maybe` module to the current file so that we can use
`Some(T)` and `None`. We are also defining our own type `linked_list<T>`. Inside the
module we can have a bunch of name - value pair to define the module content, where in
this particular case all of the members are functions. We are also defining our main
entry point to this file, which is a whole expression which returns a function that
takes in `argv` as `[string]` (list of string) and returns an `int`. Inside the `main`
section we can definitely access the members defined inside the `module` section. In
the end, the `module` members will be exposed to the files when this file gets imported,
and when this file is getting compiled as the main file, the `main` section will become
the entry point to the compiled program.

In the next sections we are going to have a much deeper look into the sections.
