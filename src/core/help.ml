open Printf

let help_text =
  "usage: menhera [options] <target>\n" ^
  "  --help | -h        Print help message\n" ^
  "  --parse | -p       Print the parsed AST\n" ^
  "  --llvm | -l        Print the compiled LLVM IR\n" ^
  "  --exec | -e        Directly execute the program"

let print_help () = printf "%s\n" help_text
