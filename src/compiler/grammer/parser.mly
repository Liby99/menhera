%{ open Ast %}

/* Variables */
%token <int> INT
%token <string> ID

/* General Symbols */
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

/* Expression Symbols */
%token LET
%token ASSIGN
%token IN
%token IF
%token THEN
%token ELSE

/* Computation Symbols */
%token PLUS
%token MINUS
%token STAR
%token SLASH
%token AND
%token OR
%token EQUAL
%token INEQUAL
%token GTE
%token LTE
%token EXCLAM

/* Section related */
%token IMPORT
%token AS
%token TYPE
%token MAIN

/* Precedence level */
%nonassoc IN
%nonassoc ELSE
%nonassoc ARROW
%left AND OR
%nonassoc EQUAL INEQUAL LANGLE GTE RANGLE LTE
%left PLUS MINUS
%left STAR SLASH
%nonassoc EXCLAM

%start <Ast.prog> prog

%%

import
: m = ID; AS; name = ID; { ImportAs(m, name) }
| name = ID; { Import(name) }
;

import_sec
: IMPORT; LBRACE; is = separated_list(COMMA, import); RBRACE; { is }
;

type_def_sig
: name = ID; LANGLE; gs = separated_list(COMMA, ID); RANGLE; { GenTypeDefSig(name, gs) }
| name = ID; { UnitTypeDefSig(name) }
;

type_sig
: name = ID; LANGLE; tss = separated_list(COMMA, type_sig); RANGLE; { GenTypeSig(name, tss) }
| name = ID; { UnitTypeSig(name) }
| LPAREN; ats = separated_list(COMMA, type_sig); RPAREN; ARROW; rt = type_sig; { FuncTypeSig(ats, rt) }
;

ctor
: name = ID; LPAREN; tss = separated_list(COMMA, type_sig); RPAREN; { CompCtor(name, tss) }
| name = ID; { UnitCtor(name) }
;

type_def
: TYPE; tds = type_def_sig; LBRACE; ctors = separated_list(COMMA, ctor); RBRACE; { TypeDef(tds, ctors) }
;

var_def
: n = ID; { Var(n) }
| n = ID; COLON; t = type_sig; { VarWithType(n, t) }
;

binding
: v = var_def; ASSIGN; e = expr; { Binding(v, e) }
;

expr_unit
: x = ID { Id(x) }
| i = INT { Int(i) }
;

expr_non_id
: e1 = expr; PLUS; e2 = expr; { BinOp(Plus, e1, e2) }
| e1 = expr; MINUS; e2 = expr; { BinOp(Minus, e1, e2) }
| e1 = expr; STAR; e2 = expr; { BinOp(Times, e1, e2) }
| e1 = expr; SLASH; e2 = expr; { BinOp(Divide, e1, e2) }
| e1 = expr; AND; e2 = expr; { BinOp(And, e1, e2) }
| e1 = expr; OR; e2 = expr; { BinOp(Or, e1, e2) }
| e1 = expr; EQUAL; e2 = expr; { BinOp(Equal, e1, e2) }
| e1 = expr; INEQUAL; e2 = expr; { BinOp(Inequal, e1, e2) }
| e1 = expr; LANGLE; e2 = expr; { BinOp(Greater, e1, e2) }
| e1 = expr; GTE; e2 = expr; { BinOp(GreaterOrEqual, e1, e2) }
| e1 = expr; RANGLE; e2 = expr; { BinOp(Less, e1, e2) }
| e1 = expr; LTE; e2 = expr; { BinOp(LessOrEqual, e1, e2) }
| EXCLAM; e = expr; { UnaOp(Not, e) }
| MINUS; e = expr; { UnaOp(Neg, e) }
| LET; bindings = separated_list(COMMA, binding); IN; body = expr; { Let(bindings, body) }
| IF; c = expr; THEN; t = expr; ELSE; e = expr; { If(c, t, e) }
| LPAREN; e = expr_non_id; RPAREN; { e }
| f = ID; LPAREN; args = separated_list(COMMA, expr); RPAREN; { App(Id(f), args) }
| LPAREN; f = expr_non_id; RPAREN; LPAREN; args = separated_list(COMMA, expr); RPAREN; { App(f, args) }
| LPAREN; args = separated_list(COMMA, var_def); RPAREN; t = option(COLON; ts = type_sig; { ts }); ARROW; body = expr; { Function(args, t, body) }
;

expr
: e = expr_unit; { e }
| e = expr_non_id; { e }
;

main_sec
: MAIN; LBRACE; e = expr; RBRACE; { e }
;

section
: is = import_sec; { ImportSect(is) }
| td = type_def; { TypeSect(td) }
| e = main_sec; { MainSect(e) }
;

sections
: { [] }
| s = section; rst = sections; { s :: rst }
;

prog
: ss = sections; EOF; { Program(ss) }
;
