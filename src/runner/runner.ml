open Llvm
open Llvm_executionengine
open Ctypes
open PosixTypes
open Foreign

let run (m : llmodule) (name : string) : int =
  (ignore (initialize ()));
  let engine = create m in
  let func = get_function_address name (funptr (void @-> returning int)) engine in
  func ()
