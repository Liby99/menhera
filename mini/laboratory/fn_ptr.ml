open Printf
open Llvm
open Runner

let context = global_context ()
let builder = builder context

let i1_t = i1_type context
let i32_t = i32_type context

let build () : llmodule =
  let m = create_module context "_module_" in

  (* Sum Function *)
  let sum_func_ty = function_type i32_t [|i32_t; i32_t|] in
  let sum_func = declare_function "sum" sum_func_ty m in
  let bb = append_block context "entry" sum_func in
  let () = position_at_end bb builder in
  let args = params sum_func in
  let a = args.(0) in
  let b = args.(1) in
  let s = build_add a b "t" builder in
  let () = ignore (build_ret s builder) in
  Llvm_analysis.assert_valid_function sum_func;

  (* Main Function *)
  let main_func_ty = function_type i32_t [||] in
  let main_func = declare_function "main" main_func_ty m in
  let bb = append_block context "entry" main_func in
  let () = position_at_end bb builder in
  let sfpty = pointer_type sum_func_ty in
  let loc = build_alloca sfpty "t" builder in
  ignore (build_store sum_func loc builder);
  let a1 = const_int i32_t 10 in
  let a2 = const_int i32_t 5 in
  let loaded = build_load loc "f" builder in
  let res = build_call loaded [|a1; a2|] "res" builder in
  let () = ignore (build_ret res builder) in
  Llvm_analysis.assert_valid_function main_func;

  m

let main () : int =
  let m = build () in
  printf "%s\n" (Llvm.string_of_llmodule m);
  let res = Runner.run m "main" in
  (printf "Runner Result: %d\n" res);
  res
;;

main ();;
