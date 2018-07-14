open Llvm
open Ast

type env =
  | Env of (env * lltype) option * (var * loc) list

and loc =
  | StackVar of llvalue (* Local Variable *)
  | HeapVar of int (* Offset *)

let rec find_vars (expr : expr) : (var * bool) list =
  match expr with
    | EId(_)
    | EInt(_)
    | EBool(_) -> []
    | EBinOp(_, e1, e2) -> (find_vars e1) @ (find_vars e2)
    | EUnaOp(_, e1) -> (find_vars e1)
    | ELet(n, e, b) ->
      let on_heap = var_on_heap (name_of_var n) b false in
      (find_vars e) @ [(n, on_heap)] @ (find_vars b)
    | EIf(c, t, e) -> (find_vars c) @ (find_vars t) @ (find_vars e)
    | EFunction(_, _, _) -> []
    | EApp(f, args) ->
      List.fold_left (fun vs v -> vs @ (find_vars v)) (find_vars f) args

and var_on_heap (name : string) (expr : expr) (nested : bool) : bool =
  match expr with
    | EId(n) -> if n = name && nested then true else false
    | EInt(_)
    | EBool(_) -> false
    | EBinOp(_, e1, e2) ->
      (var_on_heap name e1 nested) || (var_on_heap name e2 nested)
    | EUnaOp(_, e1) -> var_on_heap name e1 nested
    | ELet(v, e, b) ->
      let evoh = var_on_heap name e nested in
      if (name_of_var v) = name then evoh else evoh || (var_on_heap name b nested)
    | EIf(c, t, e) ->
      let cvoh = var_on_heap name c nested in
      let tvoh = var_on_heap name t nested in
      let evoh = var_on_heap name e nested in
      cvoh || tvoh || evoh
    | EFunction(args, _, body) ->
      begin
        try let _ = List.find (fun v -> (name_of_var v) = name) args in false
        with _ -> var_on_heap name body true
      end
    | EApp(f, args) ->
      List.fold_left (fun o c -> o || (var_on_heap name c nested)) false (f :: args)
