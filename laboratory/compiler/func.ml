open Llvm
open Ast
open Env
open GenName

exception MissingReturnTypeError

let gen_func_name = gen_name "func_"

class func (args : var list) (ret : typ option) (body : expr) (parent_env : (env * lltype) option) =
  let t_name = gen_func_name () in
  let t_args = args in
  let t_ret_typ = match ret with
    | None -> raise MissingReturnTypeError
    | Some(t) -> t
  in
  let t_body = body in
  let t_heap_vars = failwith "Not implemented"
  let t_env = Env(parent_env, []) in
  object (this)
    val name : string = t_name
    val args : var list = t_args
    val ret_typ : typ = t_ret_typ
    val body : expr = t_body
    val heap_vars : var list = t_heap_vars
    val env : env = t_env
    val heap_type : lltype =
      let typs = List.map type_of_var heap_vars in
      failwith "Get LLVM Type Not Implemented"
    method get_name () : string = name
    method get_args () : var list = args
    method get_ret_typ () : typ = ret
    method get_body () : expr = body
    method get_env () : env = env
    method get_env_type () : lltype = heap_type
    method get_env_and_type () : (env * lltype) = (env, heap_type)
    method compile (llm : llmodule) (builder : llbuilder) : llvalue =
      failwith "Not implemented"
  end;;

let rec get_funcs (expr : expr) (env : (env * lltype) option) : func list =
  match expr with
    | EId(_)
    | EInt(_)
    | EBool(_) -> []
    | EBinOp(_, e1, e2) -> (get_funcs e1 env) @ (get_funcs e2 env)
    | EUnaOp(_, e) -> get_funcs e env
    | ELet(_, e, b) -> (get_funcs e env) @ (get_funcs b env)
    | EIf(c, t, e) -> (get_funcs c env) @ (get_funcs t env) @ (get_funcs e env)
    | EFunction(args, tyo, body) ->
      let f = new func args tyo body env in
      f :: (get_funcs body (Some (f#get_env_and_type ())))
    | EApp(f, args) -> List.concat (List.map (fun e -> get_funcs e env) (f :: args))
