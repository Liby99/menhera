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
    method get_context = llctx
    method get_builder = llbdr
    method get_module = llmod
    method get_expr = expr
    method get_functions = funcs
    method get_types = typs
    method set_functions (fs : func list) = funcs <- fs;
  end

and func (args : var list) (tyo : typ option) (body : expr) (prt : func option) =
  let ty = match tyo with
    | Some(t) -> t
    | None -> raise MissingReturnTypeError
  in
  object
    val args : var list = args
    val ret_typ : typ = ty
    val body : expr = body
    val parent : func option = prt
    method get_args = args
    method get_ret_typ = ret_typ
    method get_body = body
    method get_parent = parent
  end
