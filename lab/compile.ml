open Llvm
open Ast

let context = global_context ()
let the_module = create_module context "program"
let builder = builder context

let rec compile_expr (e : expr) =
    match e with
        | EInt(i) -> const_int i32_type i
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
        | Program(e) -> compile_expr e
