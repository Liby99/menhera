open Printf
open Llvm
open Ast
open AstString

exception MissingReturnTypeError

type varloc =
  | Stack
  | Heap

let get_func_name = GenName.gen_name "func_"

class mhrcontext (expr : expr) =

  (* Generate llvm environment *)
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
    method find_type (t : typ) : (typ * lltype) option =
      List.find_opt (fun (ty, llty) -> ty = t) typs
    method get_type (t : typ) : lltype =
      match this#find_type t with
        | Some(_, llt) -> llt
        | None ->
          let llt = match t with
            | UnitType(tyname) ->
              begin
                match tyname with
                  | "int" -> i32_type llctx
                  | "bool" -> i1_type llctx
                  | _ -> failwith (sprintf "Unknown type %s" tyname)
              end
            | FunctionType(arg_typs, ret_typ) ->
              let arg_llts = Array.of_list (List.map this#get_type arg_typs) in
              let ret_llt = this#get_type ret_typ in
              function_type ret_llt arg_llts
          in
          let () = typs <- (t, llt) :: typs in
          llt
  end

and func (args : var list) (tyo : typ option) (body : expr) (prt : func option) (ctx : mhrcontext) =

  (* Generate a unique name of the function *)
  let nm = get_func_name () in
  
  (* Get the function return type *)
  let ty = match tyo with
    | Some(t) -> t
    | None -> raise MissingReturnTypeError
  in
  
  (* Generate the function type and add that to the context *)
  let func_type = FunctionType(List.map type_of_var args, ty) in
  let func_lltype = ctx#get_type func_type in
  
  object
    
    (* basic fields *)
    val ctx : mhrcontext = ctx
    val name : string = nm
    val args : var list = args
    val ret_typ : typ = ty
    val body : expr = body
    val lltyp : lltype = func_lltype
    val parent : func option = prt
    
    (* mutables *)
    val mutable var_locs : (string * typ * varloc) list = []
    
    (* getter / setters *)
    method get_name = name
    method get_args = args
    method get_ret_typ = ret_typ
    method get_body = body
    method get_parent = parent
    method get_lltype = lltyp
    method has_parent = match parent with Some(_) -> true | _ -> false
    method to_string =
      let args_str = string_of_list string_of_var args in
      let typ_str = string_of_type ret_typ in
      let body_str = string_of_expr body in
      sprintf "func(\"%s\", %s, %s, %s)" name args_str typ_str body_str
  end
