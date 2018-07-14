open Printf
open Llvm
open Ast
open AstString
open Context

let anno_func_wrapper (ctx : mhrcontext) : unit =
  let original = ctx#get_expr in
  let wrapped = EApp(EFunction([], Some(UnitType("int")), original), []) in
  ctx#set_expr wrapped

let function_printer (ctx : mhrcontext) : unit =
  let funcs_str = string_of_list (fun x -> x#to_string) (ctx#get_functions) in
  Printf.printf "%s\n" funcs_str

let func_type_printer (ctx : mhrcontext) : unit =
  let funcs_typs_str = string_of_list (fun x -> sprintf "Func: { name: \"%s\", type: %s)" x#get_name (string_of_lltype x#get_lltype)) (ctx#get_functions) in
  Printf.printf "%s\n" funcs_typs_str

let processors = [
  Unique.process;
  anno_func_wrapper;
  FunctionFinder.process;
  func_type_printer;
]

let compile (p : prog) : llmodule =
  let ctx = match p with Program(e) -> new mhrcontext e in
  let _ = List.fold_left (fun a b -> b ctx; a) () processors in
  ctx#get_module
