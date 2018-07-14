open Llvm
open Printf
open Ast
open AstString

exception MissingReturnTypeError

let get_func_name = GenName.gen_name "func_"

class mhrcontext (expr : expr) =
  let t_ctx = global_context () in
  let t_bdr = builder t_ctx in
  let t_mod = create_module t_ctx "main" in
  object (this)
    
    (* llvm related *)
    val llctx : llcontext = t_ctx
    val llbdr : llbuilder = t_bdr
    val llmod : llmodule = t_mod
    
    (* mutable fields *)
    val mutable expr : expr = expr
    val mutable funcs : func list = []
    val mutable typs : (typ * lltype) list = []
    
    (* methods *)
    method get_context = llctx
    method get_builder = llbdr
    method get_module = llmod
    method get_expr = expr
    method get_functions = funcs
    method get_types = typs
    method set_functions (fs : func list) = funcs <- fs;
    method set_expr (e : expr) = expr <- e
  end

and func (args : var list) (tyo : typ option) (body : expr) (prt : func option) =
  let nm = get_func_name () in
  let ty = match tyo with
    | Some(t) -> t
    | None -> raise MissingReturnTypeError
  in
  object
    
    (* fields *)
    val name : string = nm
    val args : var list = args
    val ret_typ : typ = ty
    val body : expr = body
    val parent : func option = prt
    
    (* getter / setters *)
    method get_args = args
    method get_ret_typ = ret_typ
    method get_body = body
    method get_parent = parent
    method has_parent = match parent with Some(_) -> true | _ -> false
    method to_string =
      let args_str = string_of_list string_of_var args in
      let typ_str = string_of_type ret_typ in
      let body_str = string_of_expr body in
      sprintf "func(\"%s\", %s, %s, %s)" name args_str typ_str body_str
  end
