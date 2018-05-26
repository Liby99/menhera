%{ open Ast %}

%token <int> INT
%token <string> ID
%token <bool> BOOL
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
%left PLUS
%left MINUS
%left TIMES
%left DIVIDE

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
    | MINUS; e = expr { UnaOp(Neg, e) }
    | NOT; e = expr { UnaOp(Not, e) }
    | LET; x = id; ASSIGN; e = expr; IN; body = expr { Let(x, e, body) }
    | IF; c = expr; THEN; t = expr; ELSE; e = expr { If(c, t, e) }
    | LPAREN; e = expr; RPAREN { e }
    | LPAREN; args = separated_list(COMMA, id); RPAREN; ARROW; body = expr { Function(args, body) }
    | f = expr; LPAREN; args = separated_list(COMMA, expr); RPAREN { App(f, args) }
;
