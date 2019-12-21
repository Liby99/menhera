%{ open Grammar %}

%token <int> INT
/* %token <string> ID */

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

/* %token LET */
/* %token ASSIGN */
/* %token IN */
/* %token IF */
/* %token THEN */
/* %token ELSE */
%token TRUE
%token FALSE

%token PLUS
%token MINUS
%token STAR
%token SLASH
/* %token EQUAL */
%token DOUBLE_EQUAL

/* %nonassoc IN */
/* %nonassoc ELSE */
/* %nonassoc ARROW */
/* %left EQUAL */
%left PLUS MINUS
%left STAR SLASH
%left DOUBLE_EQUAL

%start <Grammar.expr> entry

%%

entry
: e = expr; EOF { e }
;

expr_unit
: i = INT { Int(i) }
| TRUE { Bool(true) }
| FALSE { Bool(false) }
/* | x = ID { Var(x) } */
;

expr_non_id
: e1 = expr; PLUS; e2 = expr; { BinOp(Plus, e1, e2) }
| e1 = expr; MINUS; e2 = expr; { BinOp(Minus, e1, e2) }
| e1 = expr; STAR; e2 = expr; { BinOp(Multiply, e1, e2) }
| e1 = expr; SLASH; e2 = expr; { BinOp(Divide, e1, e2) }
| e1 = expr; DOUBLE_EQUAL; e2 = expr; { BinOp(Equal, e1, e2) }
| LPAREN; e = expr; RPAREN { e }
;

expr
: e = expr_unit; { e }
| e = expr_non_id; { e }
;