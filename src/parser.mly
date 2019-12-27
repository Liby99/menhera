%{ open Grammar %}

%token <int> INT
%token <string> ID

%token LPAREN
%token RPAREN
/* %token LBRACE */
/* %token RBRACE */
/* %token LANGLE */
/* %token RANGLE */
%token FAT_ARROW
%token THIN_ARROW
%token COMMA
%token COLON
%token EOF

%token LET
%token EQUAL
%token IN
%token IF
%token THEN
%token ELSE
%token TRUE
%token FALSE

%token PLUS
%token MINUS
%token STAR
%token SLASH
%token DOUBLE_EQUAL
%token DOUBLE_AMP
%token DOUBLE_VERT

%left FAT_ARROW
%nonassoc IN
%nonassoc ELSE
%left LPAREN
%left DOUBLE_AMP DOUBLE_VERT
%left DOUBLE_EQUAL
%left PLUS MINUS
%left STAR SLASH

%start <Grammar.expr> entry

%%

entry
: e = expr; EOF { e }
;

expr
: e = expr_unit; { e }
| e = expr_non_id; { e }
;

expr_unit
: i = INT { Int i }
| TRUE { Bool true }
| FALSE { Bool false }
| x = ID { Var x }
;

ty
: x = ID { TyId x }
| LPAREN; ts = separated_list(COMMA, ty); RPAREN; THIN_ARROW; rt = ty { TyFunction (ts, rt) }
;

arg
: x = ID; COLON; t = ty { (Id x, Some t) }
| x = ID; { (Id x, None) }
;

expr_non_id
: LPAREN; e = expr_non_id; RPAREN { e }
/* Binary Operations */
| e1 = expr; PLUS; e2 = expr; { BinOp (Plus, e1, e2) }
| e1 = expr; MINUS; e2 = expr; { BinOp (Minus, e1, e2) }
| e1 = expr; STAR; e2 = expr; { BinOp (Multiply, e1, e2) }
| e1 = expr; SLASH; e2 = expr; { BinOp (Divide, e1, e2) }
| e1 = expr; DOUBLE_AMP; e2 = expr; { BinOp (And, e1, e2) }
| e1 = expr; DOUBLE_VERT; e2 = expr; { BinOp (Or, e1, e2) }
| e1 = expr; DOUBLE_EQUAL; e2 = expr; { BinOp (Equal, e1, e2) }
/* If Expression */
| IF; c = expr; THEN; t = expr; ELSE; e = expr { If (c, t, e) }
/* Let Expression */
| LET; x = ID; EQUAL; b = expr; IN; c = expr { Let (Id x, None, b, c) }
| LET; x = ID; COLON; t = ty; EQUAL; b = expr; IN; c = expr { Let (Id x, Some t, b, c) }
/* Function Definition */
| LPAREN; args = separated_list(COMMA, arg); RPAREN; FAT_ARROW; body = expr { Function (args, None, body) }
| LPAREN; args = separated_list(COMMA, arg); RPAREN; COLON; rt = ty; FAT_ARROW; body = expr { Function (args, Some rt, body) }
/* Function Call */
| f = expr; LPAREN; args = separated_list(COMMA, expr); RPAREN { Call (f, args) }
;