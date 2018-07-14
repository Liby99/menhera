open Llvm
open Ast
open Env
open GenName

let gen_func_name = gen_name "func_"

class func (args : var list) (ret : typ) (body : expr) (parent_env : (env * lltype) option) =
  object
    val name : string = gen_func_name ()
    val mutable args : var list = args
    val mutable ret : typ = ret
    val mutable body : expr = body
    val mutable env : env = Env(parent_env, [])
    method compile (llm : llmodule) (builder : llbuilder) : llvalue =
      failwith "Not implemented"
  end;;
