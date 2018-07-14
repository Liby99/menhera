open Llvm
open Ast
open Context

let compile (p : prog) : llmodule =
  let ctx = match p with Program(e) -> new mhrcontext e in
  FunctionFinder.process ctx;
  ctx#get_module
