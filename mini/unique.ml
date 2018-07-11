open Ast
open Printf

let gen_temp =
  let count = ref 0 in
  fun () ->
    count := !count + 1;
    sprintf "%d" !count

let rec sub (e : expr) (ori : string) (upd : string) : expr =
  match e with
    | EId(name) -> if ori = name then EId(upd) else e
    | EInt(_)
    | EBool(_) -> e
    | EBinOp(op, e1, e2) -> EBinOp(op, sub e1 ori upd, sub e2 ori upd)
    | EUnaOp(op, e1) -> EUnaOp(op, sub e1 ori upd)
    | ELet(name, expr, body) ->
      let subs_expr = sub expr ori upd in
      if name = ori then ELet(name, subs_expr, body)
      else ELet(name, subs_expr, sub body ori upd)
    | EIf(c, t, e) ->
      let sc = sub c ori upd in
      let st = sub t ori upd in
      let se = sub e ori upd in
      EIf(sc, st, se)
    | EFunction(args, body) ->
      begin
        try let _ = List.find (fun n -> n = ori) args in e
        with _ -> EFunction(args, sub body ori upd)
      end
    | EApp(f, args) -> EApp(sub f ori upd, List.map (fun e -> sub e ori upd) args)

let rec prop (e : expr) : expr =
  match e with
    | EId(_)
    | EInt(_)
    | EBool(_) -> e
    | EBinOp(op, e1, e2) -> EBinOp(op, prop e1, prop e2)
    | EUnaOp(op, e1) -> EUnaOp(op, prop e1)
    | ELet(ori, expr, body) ->
      let upd = gen_temp () in
      ELet(upd, prop expr, sub (prop body) ori upd)
    | EIf(c, t, e) -> EIf(prop c, prop t, prop e)
    | EFunction(args, body) ->
      let (na, nb) = prop_func args body in
      EFunction(na, nb)
    | EApp(f, args) -> EApp(prop f, List.map prop args)

and prop_func (args : string list) (body : expr) : (string list * expr) =
  match args with
    | [] -> ([], body)
    | ori :: rst ->
      let upd = gen_temp () in
      let (na, nb) = prop_func rst (sub body ori upd) in
      (upd :: na, nb)

let process (e : expr) : expr = prop e
