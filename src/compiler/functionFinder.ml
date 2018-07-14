open Ast
open Context

let process (ctx : mhrcontext) : unit =
  
  (* Get all the function occurences in the expression *)
  let rec get_funcs (expr : expr) (prt : func option) : func list =
    match expr with
      | EId(_)
      | EInt(_)
      | EBool(_) -> []
      | EBinOp(_, e1, e2) -> (get_funcs e1 prt) @ (get_funcs e2 prt)
      | EUnaOp(_, e) -> get_funcs e prt
      | ELet(_, e, b) -> (get_funcs e prt) @ (get_funcs b prt)
      | EIf(c, t, e) -> (get_funcs c prt) @ (get_funcs t prt) @ (get_funcs e prt)
      | EFunction(args, tyo, body) ->
        let f = new func args tyo body prt in
        f :: (get_funcs body (Some f))
      | EApp(f, args) -> List.concat (List.map (fun e -> get_funcs e prt) (f :: args))
  in
  
  (* Mutate the functions in the context *)
  ctx#set_functions (get_funcs (ctx#get_expr) None);
