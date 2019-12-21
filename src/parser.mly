%{ open Grammar %}

%token <int> INT
%token <string> ID

%token LPAREN
%token RPAREN
%token LBRACE
%token RBRACE
%token LANGLE
%token RANGLE
%token ARROW
%token COMMA
%token COLON
%token EOF

%token LET
%token ASSIGN
%token IN
%token IF
%token THEN
%token ELSE

%token PLUS
%token MINUS
%token STAR
%token SLASH
%token EQUALS

%nonassoc IN
%nonassoc ELSE
%nonassoc ARROW
%left EQUALS
%left PLUS MINUS
%left STAR SLASH

%start <Ast.expr> expr

%%

expr_unit
: x = ID { Id(x) }
| i = INT { Int(i) }
;

expr_non_id
: e1 = expr; PLUS; e2 = expr; { BinOp(Plus, e1, e2) }
| e1 = expr; MINUS; e2 = expr; { BinOp(Minus, e1, e2) }
| e1 = expr; STAR; e2 = expr; { BinOp(Multiply, e1, e2) }
| e1 = expr; SLASH; e2 = expr; { BinOp(Divide, e1, e2) }
| e1 = expr; EQUALS; e2 = expr; { BinOp(Equals, e1, e2) }
| LET; bindings = separated_list(COMMA, binding); IN; body = expr; { Let(bindings, body) }
| IF; c = expr; THEN; t = expr; ELSE; e = expr; { If(c, t, e) }
;

expr
: e = expr_unit; { e }
| e = expr_non_id; { e }
;