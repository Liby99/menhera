open OUnit2

let suite = "suite" >::: ["eval" >::: Eval_test.tests]

let () = run_test_tt_main suite
