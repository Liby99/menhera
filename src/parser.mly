%{ open Grammar %}

%token <int> INT
%token <string> ID

%token LPAREN
%token RPAREN
/* %token LBRACE */
/* %token RBRACE */
/* %token LANGLE */
/* %token RANGLE */
/* %token ARROW */
/* %token COMMA */
/* %token COLON */
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

/* %nonassoc ARROW */
%nonassoc IN
%nonassoc ELSE
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
: i = INT { Int(i) }
| TRUE { Bool(true) }
| FALSE { Bool(false) }
| x = ID { Var(x) }
;

expr_non_id
: e1 = expr; PLUS; e2 = expr; { BinOp (Plus, e1, e2) }
| e1 = expr; MINUS; e2 = expr; { BinOp (Minus, e1, e2) }
| e1 = expr; STAR; e2 = expr; { BinOp (Multiply, e1, e2) }
| e1 = expr; SLASH; e2 = expr; { BinOp (Divide, e1, e2) }
| e1 = expr; DOUBLE_AMP; e2 = expr; { BinOp (And, e1, e2) }
| e1 = expr; DOUBLE_VERT; e2 = expr; { BinOp (Or, e1, e2) }
| e1 = expr; DOUBLE_EQUAL; e2 = expr; { BinOp (Equal, e1, e2) }
| LPAREN; e = expr; RPAREN { e }
| IF; c = expr; THEN; t = expr; ELSE; e = expr { If (c, t, e) }
| LET; x = ID; EQUAL; b = expr; IN; c = expr { Let (Id x, None, b, c) }
;