%{ open Ast %}

%token <int> INT

%token LPAREN RPAREN
%token EOF

%token PLUS MINUS

%left PLUS MINUS

%start <Ast.prog> prog

%%

expr
: i = INT { EInt(i) }
| LPAREN; e = expr; RPAREN; { e }
| e1 = expr; PLUS; e2 = expr; { EBinOp(Plus, e1, e2) }
| e1 = expr; MINUS; e2 = expr; { EBinOp(Minus, e1, e2) }

prog
: e = expr; EOF; { Program(e) }
