open Printf

let gen_name (base : string) : unit -> string =
  let count = ref 0 in
  fun () ->
    count := !count + 1;
    sprintf "%s%d" base !count
