Old Parser

``` OCaml
%{ open Ast %}

%token <int> INT
%token <string> ID
%token <bool> BOOL
%token <string> STRING
%token PLUS
%token MINUS
%token TIMES
%token DIVIDE
%token AND
%token OR
%token GT
%token GTE
%token LT
%token LTE
%token EQUALS
%token NOT
%token VERT
%token LPAREN
%token RPAREN
%token LBRACKET
%token RBRACKET
%token COMMA
%token ARROW
%token LET
%token ASSIGN
%token IN
%token IF
%token THEN
%token ELSE
%token EOF

%nonassoc IN
%nonassoc ARROW
%left CONCAT
%left EQUALS LTE LT GTE GT
%left OR AND
%left MINUS PLUS
%left DIVIDE TIMES

%start <Ast.expr> prog

%%

prog:
    | e = expr; EOF { e }
;

exprs:
    | es = separated_list(COMMA, expr); { es }

id:
    | x = ID { Id(x) }
;

ids:
    | ids = separated_list(COMMA, id); { ids }
;

bind:
    | x = id; ASSIGN; e = expr; { (x, e) }

expr:
    | i = INT { Int(i) }
    | b = BOOL { Bool(b) }
    | x = ID { Var(x) }
    | s = STRING { String(s) }
    | e1 = expr; TIMES; e2 = expr { BinOp(Times, e1, e2) }
    | e1 = expr; DIVIDE; e2 = expr { BinOp(Divide, e1, e2) }
    | e1 = expr; PLUS; e2 = expr { BinOp(Plus, e1, e2) }
    | e1 = expr; MINUS; e2 = expr { BinOp(Minus, e1, e2) }
    | e1 = expr; AND; e2 = expr { BinOp(And, e1, e2) }
    | e1 = expr; OR; e2 = expr { BinOp(Or, e1, e2) }
    | e1 = expr; GT; e2 = expr { BinOp(Greater, e1, e2) }
    | e1 = expr; GTE; e2 = expr { BinOp(GreaterOrEqual, e1, e2) }
    | e1 = expr; LT; e2 = expr { BinOp(Less, e1, e2) }
    | e1 = expr; LTE; e2 = expr { BinOp(LessOrEqual, e1, e2) }
    | e1 = expr; EQUALS; e2 = expr { BinOp(Equals, e1, e2) }
    | VERT; e = expr; VERT { UnaOp(Length, e) }
    | MINUS; e = expr { UnaOp(Neg, e) }
    | NOT; e = expr { UnaOp(Not, e) }
    | LET; bs = separated_list(COMMA, bind); IN; body = expr { Let(bs, body) }
    | IF; c = expr; THEN; t = expr; ELSE; e = expr { If(c, t, e) }
    | LPAREN; e = expr; RPAREN { e }
    | LBRACKET; es = exprs; RBRACKET; { List(es) }
    | LBRACKET; RBRACKET; { List([]) }
    | arr = expr; LBRACKET; i = expr; RBRACKET; { BinOp(ListGet, arr, i) }
    | LPAREN; is = ids; RPAREN; ARROW; body = expr { Function(is, body) }
    | f = expr; LPAREN; args = separated_list(COMMA, expr); RPAREN { App(f, args) }
;
```