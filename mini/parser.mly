%{ open Ast %}

%token <string> ID
%token <int> INT
%token <bool> BOOL

%token LPAREN RPAREN
%token EOF

%token LET ASSIGN IN

%token PLUS MINUS

%nonassoc IN
%left PLUS MINUS

%start <Ast.prog> prog

%%

expr
: x = ID { EId(x) }
| b = BOOL { EBool(b) }
| i = INT { EInt(i) }
| LPAREN; e = expr; RPAREN; { e }
| e1 = expr; PLUS; e2 = expr; { EBinOp(Plus, e1, e2) }
| e1 = expr; MINUS; e2 = expr; { EBinOp(Minus, e1, e2) }
| LET; n = ID; ASSIGN; e = expr; IN; b = expr; { ELet(n, e, b) }

prog
: e = expr; EOF; { Program(e) }