open Printf

open Llvm
open Ast

let context = global_context ()
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
        | EBool(b) -> const_int i32_t (if b then 1 else 0)
        | EBinOp(op, e1, e2) ->
            let lhs = compile_expr e1 env in
            let rhs = compile_expr e2 env in
            begin
                match op with
                    | Plus -> build_add lhs rhs "t" builder
                    | Minus -> build_sub lhs rhs "t" builder
                    | And -> build_and lhs rhs "t" builder
                    | Or -> build_or lhs rhs "t" builder
                    | Equal -> build_icmp Icmp.Eq lhs rhs "t" builder
                    | Inequal -> build_icmp Icmp.Ne lhs rhs "t" builder
                    | Greater -> build_icmp Icmp.Sgt lhs rhs "t" builder
                    | GreaterOrEqual -> build_icmp Icmp.Sge lhs rhs "t" builder
                    | Less -> build_icmp Icmp.Slt lhs rhs "t" builder
                    | LessOrEqual -> build_icmp Icmp.Sle lhs rhs "t" builder
            end
        | EUnaOp(op, e) ->
            let es = compile_expr e env in
            begin
                match op with
                    | Not -> build_xor es (const_int i32_t 1) "t" builder
            end
        | ELet(n, e, b) ->
            let nv = (n, compile_expr e env) in
            compile_expr b (nv :: env)
        | EIf(c, t, e) ->
            let cond = compile_expr c env in
            let cond_val = build_icmp Icmp.Eq cond (const_int i32_t 1) "ifcond" builder in
            let start_bb = insertion_block builder in
            let parent = block_parent start_bb in

            (* Then *)
            let then_bb = append_block context "then" parent in
            position_at_end then_bb builder;
            let then_val = compile_expr t env in
            let new_then_bb = insertion_block builder in

            (* Else *)
            let else_bb = append_block context "else" parent in
            position_at_end else_bb builder;
            let else_val = compile_expr e env in
            let new_else_bb = insertion_block builder in

            (* Continue *)
            let merge_bb = append_block context "ifcont" parent in
            position_at_end merge_bb builder;
            let incoming = [(then_val, new_then_bb); (else_val, new_else_bb)] in
            let phi = build_phi incoming "iftmp" builder in

            (* Prologue *)
            position_at_end start_bb builder;
            ignore (build_cond_br cond_val then_bb else_bb builder);
            position_at_end new_then_bb builder; ignore (build_br merge_bb builder);
            position_at_end new_else_bb builder; ignore (build_br merge_bb builder);
            position_at_end merge_bb builder;

            phi

let rec compile_prog (p : prog) : llmodule =
    match p with
        | Program(e) ->
            let m = create_module context "mini" in
            let mainty = function_type i32_t [||] in
            let main = declare_function "main" mainty m in
            let bb = append_block context "entry" main in
            let () = position_at_end bb builder in
            let body = compile_expr e [] in
            let () = ignore (build_ret body builder) in
            Llvm_analysis.assert_valid_function main;
            m
