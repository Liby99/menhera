open Ast
open GenName
open Context

let process (ctx : mhrcontext) : unit =

  let gen_temp = gen_name "" in
  
  let new_var (ori : var) (upd_str : string) =
    match ori with
      | Var(_) -> Var(upd_str)
      | TypedVar(_, t) -> TypedVar(upd_str, t)
  in
  
  let rec sub (e : expr) (ori : string) (upd : string) : expr =
    match e with
      | EId(name) -> if ori = name then EId(upd) else e
      | EInt(_)
      | EBool(_) -> e
      | EBinOp(op, e1, e2) -> EBinOp(op, sub e1 ori upd, sub e2 ori upd)
      | EUnaOp(op, e1) -> EUnaOp(op, sub e1 ori upd)
      | ELet(var, expr, body) ->
        let subs_expr = sub expr ori upd in
        let name = name_of_var var in
        if name = ori then ELet(var, subs_expr, body)
        else ELet(var, subs_expr, sub body ori upd)
      | EIf(c, t, e) ->
        let sc = sub c ori upd in
        let st = sub t ori upd in
        let se = sub e ori upd in
        EIf(sc, st, se)
      | EFunction(args, tyo, body) ->
        begin
          try let _ = List.find (fun v -> (name_of_var v) = ori) args in e
          with _ -> EFunction(args, tyo, sub body ori upd)
        end
      | EApp(f, args) -> EApp(sub f ori upd, List.map (fun e -> sub e ori upd) args)
  in
  
  let rec prop (e : expr) : expr =
    match e with
      | EId(_)
      | EInt(_)
      | EBool(_) -> e
      | EBinOp(op, e1, e2) -> EBinOp(op, prop e1, prop e2)
      | EUnaOp(op, e1) -> EUnaOp(op, prop e1)
      | ELet(ori, expr, body) ->
        let upd = gen_temp () in
        let upd_var = new_var ori upd in
        ELet(upd_var, prop expr, sub (prop body) (name_of_var ori) upd)
      | EIf(c, t, e) -> EIf(prop c, prop t, prop e)
      | EFunction(args, tyo, body) ->
        let (na, nb) = prop_func args body in
        EFunction(na, tyo, nb)
      | EApp(f, args) -> EApp(prop f, List.map prop args)
  
  and prop_func (args : var list) (body : expr) : (var list * expr) =
    match args with
      | [] -> ([], body)
      | ori :: rst ->
        let upd = gen_temp () in
        let (na, nb) = prop_func rst (sub body (name_of_var ori) upd) in
        let upd_var = new_var ori upd in
        (upd_var :: na, nb)
  in
  
  ctx#set_expr (prop (ctx#get_expr));
