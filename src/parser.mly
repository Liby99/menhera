%{ open Ast %}

%token <int> INT
%token <string> ID
%token <bool> BOOL
%token PLUS
%token MINUS
%token TIMES
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
    | x = ID { Id x }
;

expr:
    | i = INT { Int i }
    | b = BOOL { Bool b }
    | x = id { x }
    | e1 = expr; PLUS; e2 = expr { Add(e1, e2) }
    | e1 = expr; MINUS; e2 = expr { Minus(e1, e2) }
    | e1 = expr; TIMES; e2 = expr { Times(e1, e2) }
    | LET; x = ID; EQUALS; e = expr; IN; body = expr { Let(x, e, body) }
    | IF; c = expr; THEN; t = expr; ELSE; e = expr { If(c, t, e) }
    | LPAREN; e = expr; RPAREN { e }
    | LPAREN; args = separated_list(COMMA, id); RPAREN; ARROW; body = expr { Function(args, body) }
    | f = id; LPAREN; args = separated_list(COMMA, expr); RPAREN { App(f, args) }
;
