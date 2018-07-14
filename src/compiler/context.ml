open Llvm
open Ast

exception MissingReturnTypeError

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
    method get_module = llmod
  end
  
and func (args : var list) (tyo : typ option) (body : expr) (parent : func option) =
  let typ = match tyo with
    | Some(t) -> t
    | None -> raise MissingReturnTypeError
  in
  object
    val args : var list = args
    val ret_typ : typ = typ
    val body : expr = body
    val parent : func option = parent
  end
