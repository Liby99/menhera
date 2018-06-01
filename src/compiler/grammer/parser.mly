%{ open Ast %}

/* Variables */
%token <string> ID
%token <int> INT
%token <bool> BOOL
%token <float> FLOAT
%token <string> STRING

/* General Symbols */
%token LPAREN RPAREN
%token LBRACE RBRACE
%token LANGLE RANGLE
%token LBRACK RBRACK
%token MODID ARROW COMMA QUESTION COLON
%token EOF

/* Expression Symbols */
%token LET ASSIGN IN
%token IF THEN ELSE

/* Computation Symbols */
%token PLUS MINUS STAR SLASH
%token AND OR
%token EQUAL INEQUAL
%token GTE LTE
%token EXCLAM
%token DOLLAR
%token VBAR

/* Section related */
%token IMPORT AS
%token TYPE
%token MAIN

/* Precedence level */
%nonassoc IN
%nonassoc ELSE
%nonassoc ARROW
%right LBRACK
%right QUESTION COLON
%left AND OR
%nonassoc EQUAL INEQUAL LANGLE GTE RANGLE LTE
%left PLUS MINUS
%left STAR SLASH
%nonassoc EXCLAM
%nonassoc DOLLAR

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
| LBRACK; t = type_sig; RBRACK; { ListTypeSig(t) }
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
| m = ID; MODID; x = ID; { ModuleId(m, x) }
| i = INT { Int(i) }
| b = BOOL { Bool(b) }
| f = FLOAT { Float(f) }
| s = STRING { String(s) }
| LBRACK; es = separated_list(COMMA, expr); RBRACK; { List(es) }
;

expr_comp
: e1 = expr; PLUS; e2 = expr; { BinOp(Plus, e1, e2) }
| e1 = expr; MINUS; e2 = expr; { BinOp(Minus, e1, e2) }
| e1 = expr; STAR; e2 = expr; { BinOp(Times, e1, e2) }
| e1 = expr; SLASH; e2 = expr; { BinOp(Divide, e1, e2) }
| e1 = expr; AND; e2 = expr; { BinOp(And, e1, e2) }
| e1 = expr; OR; e2 = expr; { BinOp(Or, e1, e2) }
| e1 = expr; EQUAL; e2 = expr; { BinOp(Equal, e1, e2) }
| e1 = expr; INEQUAL; e2 = expr; { BinOp(Inequal, e1, e2) }
| e1 = expr; RANGLE; e2 = expr; { BinOp(Greater, e1, e2) }
| e1 = expr; GTE; e2 = expr; { BinOp(GreaterOrEqual, e1, e2) }
| e1 = expr; LANGLE; e2 = expr; { BinOp(Less, e1, e2) }
| e1 = expr; LTE; e2 = expr; { BinOp(LessOrEqual, e1, e2) }
| EXCLAM; e = expr; { UnaOp(Not, e) }
| MINUS; e = expr; { UnaOp(Neg, e) }
| DOLLAR; e = expr; { UnaOp(Str, e) }
| VBAR; e = expr; VBAR; { UnaOp(Len, e) }
| a = expr; LBRACK; i = expr; RBRACK; { BinOp(ListGet, a, i) }
| LET; bindings = separated_list(COMMA, binding); IN; body = expr; { Let(bindings, body) }
| IF; c = expr; THEN; t = expr; ELSE; e = expr; { If(c, t, e) }
| c = expr; QUESTION; t = expr; COLON; e = expr; { If(c, t, e) }
| LPAREN; e = expr_comp; RPAREN; { e }
| f = expr_unit; LPAREN; args = separated_list(COMMA, expr); RPAREN; { App(f, args) }
| LPAREN; f = expr_comp; RPAREN; LPAREN; args = separated_list(COMMA, expr); RPAREN; { App(f, args) }
| LPAREN; args = separated_list(COMMA, var_def); RPAREN; t = option(COLON; ts = type_sig; { ts }); ARROW; body = expr; { Function(args, t, body) }
;

expr
: e = expr_unit; { e }
| e = expr_comp; { e }
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
