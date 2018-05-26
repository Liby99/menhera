%{ open Ast %}

%token <int> INT
%token <string> ID
%token <bool> BOOL
%token PLUS
%token MINUS
%token TIMES
%token NOT
%token LPAREN
%token RPAREN
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
%left PLUS
%left MINUS
%left TIMES

%start <Ast.expr> prog

%%

prog:
    | e = expr; EOF { e }
;

id:
    | x = ID { Id(x) }
;

expr:
    | i = INT { Int(i) }
    | b = BOOL { Bool(b) }
    | x = ID { Var(x) }
    | e1 = expr; PLUS; e2 = expr { BinOp(Plus, e1, e2) }
    | e1 = expr; MINUS; e2 = expr { BinOp(Minus, e1, e2) }
    | e1 = expr; TIMES; e2 = expr { BinOp(Times, e1, e2) }
    | MINUS; e = expr { UnaOp(Neg, e) }
    | NOT; e = expr { UnaOp(Not, e) }
    | LET; x = id; ASSIGN; e = expr; IN; body = expr { Let(x, e, body) }
    | IF; c = expr; THEN; t = expr; ELSE; e = expr { If(c, t, e) }
    | LPAREN; e = expr; RPAREN { e }
    | LPAREN; args = separated_list(COMMA, id); RPAREN; ARROW; body = expr { Function(args, body) }
    | f = expr; LPAREN; args = separated_list(COMMA, expr); RPAREN { App(f, args) }
;
