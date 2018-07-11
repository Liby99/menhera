open Printf
open Llvm
open Ast
open Env

exception UnboundVariable of string

let context = global_context ()
let builder = builder context

let i1_t = i1_type context

let i32_t = i32_type context

let rec compile_expr (e : expr) (env : env) : llvalue =
    match e with
        | EId(n) ->
            begin
                match find n env with
                    | Some(StackVar(v)) -> v
                    | Some(HeapVar(_, _)) -> failwith "Not implemented"
                    | None -> raise (UnboundVariable (sprintf "Unbound variable %s" n))
            end
        | EInt(i) -> const_int i32_t i
        | EBool(b) -> const_int i1_t (if b then 1 else 0)
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
                    | Not -> build_xor es (const_int i1_t 1) "t" builder
            end
        | ELet(name, expr, body) ->
            let cpv = compile_expr expr env in
            let nenv = match env with Env(eo, stk, hp) ->
                match find_in_heap name hp with
                    | Some(off) -> failwith "Not implemented"
                    | None -> Env(eo, (name, cpv) :: stk, hp)
            in compile_expr body nenv
        | EIf(c, t, e) -> compile_expr_if c t e env
        | EFunction(args, body) -> compile_function args body env
        | EApp(fs, args) -> failwith "Not implemented"

and compile_expr_if (c : expr) (t : expr) (e : expr) (env : env) : llvalue =

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

and compile_function (args : string list) (body : expr) (env : env) : llvalue =
    (* let hp_vars = unbound_vars body args in
    Printf.printf "%s\n" (AstString.string_of_string_list hp_vars);
    let curr_env = Env(Some(env), [], []) in *)
    failwith "Not implemented"

and compile_prog (p : prog) : llmodule =
    match p with
        | Program(e) ->
            let ne = Unique.process e in
            let m = create_module context "mini" in
            let mainty = function_type i32_t [||] in
            let main = declare_function "main" mainty m in
            let bb = append_block context "entry" main in
            let () = position_at_end bb builder in
            let env = Env(None, [], []) in
            let body = compile_expr ne env in
            let () = ignore (build_ret body builder) in
            Llvm_analysis.assert_valid_function main;
            m
