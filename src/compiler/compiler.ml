open Llvm
open Ast
open Func

class mhrcontext (expr : expr) =
  let t_ctx = global_context () in
  let t_bdr = builder t_ctx in
  let t_mod = create_module t_ctx "main" in
  object (this)
    val llctx : llcontext = t_ctx
    val llbdr : llbuilder = t_bdr
    val llmod : llmodule = t_mod
    val mutable expr : expr = expr
    val mutable funcs : func list = []
    val mutable typs : (typ * lltype) list = []
  end;;

let compile (p : prog) : llmodule =
  (* let ctx = match p with Program(e) -> new mhrcontext e in *)
  failwith "Not implemented"
