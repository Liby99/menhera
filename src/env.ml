open Llvm
open Ast

type env =
    (* env option: parent environment, None if is the outer-most env
       (string * llvalue) list: local variables
       (string * int) list: heap variables, int is the offset (in bytes) *)
    | Env of env option * (string * llvalue) list * (string * int) list

type var =
    (* llvalue: the local llvalue that this variable refer to *)
    | StackVar of llvalue
    (*  (int * int):
        1st int is the number of env link to trace back through,
        2nd int is the offset in that env link *)
    | HeapVar of int * int

let rec unbound_vars (e : expr) (stkenv : string list) : string list =
    match e with
        | EId(n) ->
            begin
                try let _ = List.find (fun x -> x = n) stkenv in []
                with _ -> [n]
            end
        | EInt(_)
        | EBool(_) -> []
        | EBinOp(_, e1, e2) -> (unbound_vars e1 stkenv) @ (unbound_vars e2 stkenv)
        | EUnaOp(_, e) -> unbound_vars e stkenv
        | ELet(n, e, b) -> (unbound_vars e stkenv) @ (unbound_vars b (n :: stkenv))
        | EIf(c, t, e) ->
            let uvc = unbound_vars c stkenv in
            let uvt = unbound_vars t stkenv in
            let uve = unbound_vars e stkenv in
            uvc @ uvt @ uve
        | EFunction(ps, b) -> unbound_vars b (ps @ stkenv)
        | EApp(f, args) ->
            let uvf = unbound_vars f stkenv in
            let uvargs = List.flatten (List.map (fun e -> unbound_vars e stkenv) args) in
            uvf @ uvargs

let rec find (name : string) (e : env) : var option =
    match e with
        | Env(_, stk, _) ->
            let stkv = find_in_stack name stk in
            match stkv with
                | Some(v) -> Some(StackVar(v))
                | None -> find_in_env name e 0

and find_in_env (name : string) (e : env) (access_count : int) : var option =
    match e with
        | Env(eo, _, hp) ->
            let hpv = find_in_heap name hp in
            match hpv with
                | Some(v) -> Some(HeapVar(access_count, v))
                | None ->
                    match eo with
                        | Some(pe) -> find_in_env name pe (access_count + 1)
                        | None -> None

and find_in_stack (name : string) (stk : (string * llvalue) list) : llvalue option =
    try
        match List.find (fun (n, _) -> n = name) stk with
            | (_, v) -> Some(v)
    with
        | _ -> None

and find_in_heap (name : string) (heap : (string * int) list) : int option =
    try
        match List.find (fun (n, _) -> n = name) heap with
            | (_, v) -> Some(v)
    with
        | _ -> None
