# Language design

We want

JavaScript like function syntax
Rust like Trait/Type Class, Typing Scheme
OCaml like If/Else/Let/In

```
type List<T> = Cons(T, List<T>) | Nil;

impl List<T> {
  empty = Nil ;
  singleton = (e) => Cons(e, Nil) ;
  prepend = (l, e) => Cons(e, l) ;
  append = (l, e) => match l {
    Cons(hd, tl) => Cons(hd, tl.append(e)),
    Nil => Cons(e, Nil)
  } ;
}

let main = () => {

}
```

```
type List = (T) => {
  Cons(T, List<T>) | Nil with {

    // Return an empty list
    empty = Nil

    // Create a list with just a single element e
    singleton = (e) => Cons(e, Nil)

    // Prepend an element to a list
    prepend = (l, e) => Cons(e, l)

    // Append an element to a list
    append = (l, e) => match l {
      Cons(hd, tl) => Cons(hd, tl.append(e)),
      Nil => Cons(e, Nil)
    }

    // List comparison
    `==` = (l1, l2) => match (l1, l2) {
      (Cons(h1, t1), Cons(h2, t2)) => h1 == h2 && t1 == t2,
      (Nil, Nil) => true,
      _ => false
    } where T : Compare

    // Check if a list is empty
    is_empty = (l) => l == Nil
  }
}
```