open Printf

open Llvm
open Ast

let context = global_context ()
let _module = create_module context "mini"
let builder = builder context

let i32_t = i32_type context

let rec find_in_env (env : (string * llvalue) list) (name : string) : llvalue =
    match env with
        | [] -> failwith (sprintf "Unbound variable %s" name)
        | (n, v) :: rst -> if n = name then v else find_in_env rst name

let rec compile_expr (e : expr) (env : (string * llvalue) list) : llvalue =
    match e with
        | EId(n) -> find_in_env env n
        | EInt(i) -> const_int i32_t i
        | EBinOp(op, e1, e2) ->
            let lhs = compile_expr e1 env in
            let rhs = compile_expr e2 env in
            begin
                match op with
                    | Plus -> build_add lhs rhs "t" builder
                    | Minus -> build_sub lhs rhs "t" builder
            end
        | ELet(n, e, b) ->
            let nv = (n, compile_expr e env) in
            compile_expr b (nv :: env)

let rec compile_prog (p : prog) =
    match p with
        | Program(e) ->
            let mainty = function_type i32_t [||] in
            let main = declare_function "main" mainty _module in
            let bb = append_block context "entry" main in
            let () = position_at_end bb builder in
            let body = compile_expr e [] in
            let () = ignore (build_ret body builder) in
            main
