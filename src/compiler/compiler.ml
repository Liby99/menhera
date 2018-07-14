open Llvm
open Ast
open Context

let anno_func_wrapper (ctx : mhrcontext) : unit =
  let original = ctx#get_expr in
  let wrapped = EApp(EFunction([], Some(UnitType("int")), original), []) in
  ctx#set_expr wrapped

let processors = [
  Unique.process;
  anno_func_wrapper;
  FunctionFinder.process;
  (fun (ctx : mhrcontext) ->
    Printf.printf "%s\n" (AstString.string_of_list (fun x -> x#to_string) (ctx#get_functions));
  );
]

let compile (p : prog) : llmodule =
  let ctx = match p with Program(e) -> new mhrcontext e in
  let _ = List.fold_left (fun a b -> b ctx; a) () processors in
  ctx#get_module
