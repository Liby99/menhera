open Llvm
open Ast

let context = global_context ()
let _module = create_module context "mini"
let builder = builder context

let i32_t = i32_type context

let rec compile_expr (e : expr) =
    match e with
        | EInt(i) -> const_int i32_t i
        | EBinOp(op, e1, e2) ->
            let lhs = compile_expr e1 in
            let rhs = compile_expr e2 in
            begin
                match op with
                    | Plus -> build_add lhs rhs "addtmp" builder
                    | Minus -> build_sub lhs rhs "subtmp" builder
            end

let rec compile_prog (p : prog) =
    match p with
        | Program(e) ->
            let mainty = function_type i32_t [||] in
            let main = declare_function "main" mainty _module in
            let bb = append_block context "entry" main in
            let () = position_at_end bb builder in
            let body = compile_expr e in
            let () = ignore (build_ret body builder) in
            dump_value main;
            main
