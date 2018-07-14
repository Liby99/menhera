open Llvm
open Ast
open Context

let processors = [
  FunctionFinder.process;
]

let compile (p : prog) : llmodule =
  let ctx = match p with Program(e) -> new mhrcontext e in
  let _ = List.fold_left (fun a b -> b ctx; a) () processors in
  ctx#get_module
