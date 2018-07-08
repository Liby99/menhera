%{ open Ast %}

%token <string> ID
%token <int> INT
%token <bool> BOOL

%token EOF
%token LPAREN RPAREN
%token LANGLE RANGLE
%token RPAREN_ARROW COMMA QUESTION COLON

%token LET ASSIGN IN
%token IF THEN ELSE

%token PLUS MINUS
%token AND OR
%token EQUAL INEQUAL
%token GTE LTE
%token EXCLAM

%nonassoc IN
%left LPAREN (* Function Application Left Associative *)
%right RPAREN_ARROW (* Function Definition Right Associative *)
%nonassoc ELSE
%right QUESTION COLON
%left AND OR
%nonassoc EQUAL INEQUAL LANGLE GTE RANGLE LTE
%left PLUS MINUS
%nonassoc EXCLAM

%start <Ast.prog> prog

%%

expr
: x = ID { EId(x) }
| b = BOOL { EBool(b) }
| i = INT { EInt(i) }
| LPAREN; e = expr; RPAREN; { e }
| e1 = expr; PLUS; e2 = expr; { EBinOp(Plus, e1, e2) }
| e1 = expr; MINUS; e2 = expr; { EBinOp(Minus, e1, e2) }
| e1 = expr; AND; e2 = expr; { EBinOp(And, e1, e2) }
| e1 = expr; OR; e2 = expr; { EBinOp(Or, e1, e2) }
| e1 = expr; EQUAL; e2 = expr; { EBinOp(Equal, e1, e2) }
| e1 = expr; INEQUAL; e2 = expr; { EBinOp(Inequal, e1, e2) }
| e1 = expr; RANGLE; e2 = expr; { EBinOp(Greater, e1, e2) }
| e1 = expr; GTE; e2 = expr; { EBinOp(GreaterOrEqual, e1, e2) }
| e1 = expr; LANGLE; e2 = expr; { EBinOp(Less, e1, e2) }
| e1 = expr; LTE; e2 = expr; { EBinOp(LessOrEqual, e1, e2) }
| EXCLAM; e = expr; { EUnaOp(Not, e) }
| LET; n = ID; ASSIGN; e = expr; IN; b = expr; { ELet(n, e, b) }
| IF; c = expr; THEN; t = expr; ELSE; e = expr; { EIf(c, t, e) }
| c = expr; QUESTION; t = expr; COLON; e = expr; { EIf(c, t, e) }
| LPAREN; args = separated_list(COMMA, ID); RPAREN_ARROW; body = expr; { EFunction(args, body) }
| f = expr; LPAREN; args = separated_list(COMMA, expr); RPAREN; { EApp(f, args) }

prog
: e = expr; EOF; { Program(e) }
