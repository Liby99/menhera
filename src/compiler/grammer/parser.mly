%{ open Ast %}

/* Variables */
%token <string> ID
%token <int> INT
%token <bool> BOOL
%token <float> FLOAT
%token <string> STRING
%token WILDCARD

/* General Symbols */
%token LPAREN RPAREN
%token LBRACE RBRACE
%token LANGLE RANGLE
%token LBRACK RBRACK
%token EMPTYBRACK
%token MODID BACKQUOTE ARROW COMMA QUESTION COLON
%token EOF

/* Expression Symbols */
%token LET ASSIGN IN
%token IF THEN ELSE
%token MATCH

/* Computation Symbols */
%token PLUS MINUS STAR SLASH PERC
%token AND OR
%token EQUAL INEQUAL
%token GTE LTE
%token EXCLAM
%token DOLLAR
%token SHARP

/* Section related */
%token IMPORT AS FROM HIDING
%token TYPE
%token MODULE
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
%left PERC
%nonassoc EXCLAM DOLLAR SHARP

%start <Ast.prog> prog

%%

import
: name = ID; { Import(name) }
| m = ID; AS; name = ID; { ImportAs(m, name) }
| STAR; FROM; m = ID; { ImportAll(m) }
| LBRACE; ms = separated_list(COMMA, ID); RBRACE; FROM; m = ID; { ImportMember(m, ms) }
| m = ID; HIDING; LBRACE; ms = separated_list(COMMA, ID); RBRACE; { ImportHiding(m, ms) }
;

import_sec
: IMPORT; LBRACE; is = separated_list(COMMA, import); RBRACE; { is }
;

id
: n = ID; { Id(n) }
| m = ID; MODID; n = ID; { ModuleId(m, n) }

type_def_sig
: name = ID; LANGLE; gs = separated_list(COMMA, ID); RANGLE; { GenTypeDefSig(name, gs) }
| name = ID; { UnitTypeDefSig(name) }
;

type_sig
: i = id; { UnitTypeSig(i) }
| i = id; LANGLE; tss = separated_list(COMMA, type_sig); RANGLE; { GenTypeSig(i, tss) }
| LPAREN; ats = separated_list(COMMA, type_sig); RPAREN; ARROW; rt = type_sig; { FuncTypeSig(ats, rt) }
| LBRACK; t = type_sig; RBRACK; { ListTypeSig(t) }
;

ctor_def
: name = ID; LPAREN; tss = separated_list(COMMA, type_sig); RPAREN; { CompCtor(name, tss) }
| name = ID; { UnitCtor(name) }
;

type_def
: TYPE; tds = type_def_sig; LBRACE; ctors = separated_list(COMMA, ctor_def); RBRACE; { TypeDef(tds, ctors) }
;

operator
: PLUS; { OperatorBin(Plus) }
| MINUS; { OperatorBin(Minus) }
| STAR; { OperatorBin(Times) }
| SLASH; { OperatorBin(Divide) }
| PERC; { OperatorBin(Mod) }
| AND; { OperatorBin(And) }
| OR; { OperatorBin(Or) }
| EQUAL; { OperatorBin(Equal) }
| INEQUAL; { OperatorBin(Inequal) }
| RANGLE; { OperatorBin(Greater) }
| GTE; { OperatorBin(GreaterOrEqual) }
| LANGLE; { OperatorBin(Less) }
| LTE; { OperatorBin(LessOrEqual) }
| EMPTYBRACK; { OperatorBin(ListGet) }
| EXCLAM; { OperatorUna(Not) }
| DOLLAR; { OperatorUna(Str) }
| SHARP; { OperatorUna(Len) }
;

var_def
: n = ID; { Var(n) }
| n = ID; COLON; t = type_sig; { VarWithType(n, t) }
| BACKQUOTE; o = operator; BACKQUOTE; { Operator(o) }
| BACKQUOTE; o = operator; BACKQUOTE; COLON; t = type_sig; { OperatorWithType(o, t) }
;

pattern
: WILDCARD; { PWildCard }
| x = id { PId(x) }
| i = INT { PInt(i) }
| b = BOOL { PBool(b) }
| f = FLOAT { PFloat(f) }
| s = STRING { PString(s) }
| LBRACK; ps = separated_list(COMMA, pattern); RBRACK; { PList(ps) }
| x = id; LPAREN; ps = separated_list(COMMA, pattern); RPAREN; { PApp(PId(x), ps) }
;

expr_unit
: x = id { EId(x) }
| i = INT { EInt(i) }
| b = BOOL { EBool(b) }
| f = FLOAT { EFloat(f) }
| s = STRING { EString(s) }
| LBRACK; es = separated_list(COMMA, expr); RBRACK; { EList(es) }
;

expr_comp
: LPAREN; e = expr_comp; RPAREN; { e }
| e1 = expr; PLUS; e2 = expr; { EBinOp(Plus, e1, e2) }
| e1 = expr; MINUS; e2 = expr; { EBinOp(Minus, e1, e2) }
| e1 = expr; STAR; e2 = expr; { EBinOp(Times, e1, e2) }
| e1 = expr; SLASH; e2 = expr; { EBinOp(Divide, e1, e2) }
| e1 = expr; PERC; e2 = expr; { EBinOp(Mod, e1, e2) }
| e1 = expr; AND; e2 = expr; { EBinOp(And, e1, e2) }
| e1 = expr; OR; e2 = expr; { EBinOp(Or, e1, e2) }
| e1 = expr; EQUAL; e2 = expr; { EBinOp(Equal, e1, e2) }
| e1 = expr; INEQUAL; e2 = expr; { EBinOp(Inequal, e1, e2) }
| e1 = expr; RANGLE; e2 = expr; { EBinOp(Greater, e1, e2) }
| e1 = expr; GTE; e2 = expr; { EBinOp(GreaterOrEqual, e1, e2) }
| e1 = expr; LANGLE; e2 = expr; { EBinOp(Less, e1, e2) }
| e1 = expr; LTE; e2 = expr; { EBinOp(LessOrEqual, e1, e2) }
| a = expr; LBRACK; i = expr; RBRACK; { EBinOp(ListGet, a, i) }
| EXCLAM; e = expr; { EUnaOp(Not, e) }
| MINUS; e = expr; { EUnaOp(Neg, e) }
| DOLLAR; e = expr; { EUnaOp(Str, e) }
| SHARP; e = expr; { EUnaOp(Len, e) }
| LET; bindings = separated_list(COMMA, v = var_def; ASSIGN; e = expr; { (v, e) }); IN; body = expr; { ELet(bindings, body) }
| IF; c = expr; THEN; t = expr; ELSE; e = expr; { EIf(c, t, e) }
| c = expr; QUESTION; t = expr; COLON; e = expr; { EIf(c, t, e) }
| MATCH; LPAREN; t = expr; RPAREN; LBRACE; pes = separated_list(COMMA, p = pattern; ARROW; e = expr; { (p, e) }); RBRACE; { EMatch(t, pes) }
| f = expr_unit; LPAREN; args = separated_list(COMMA, expr); RPAREN; { EApp(f, args) }
| LPAREN; f = expr_comp; RPAREN; LPAREN; args = separated_list(COMMA, expr); RPAREN; { EApp(f, args) }
| LPAREN; args = separated_list(COMMA, var_def); RPAREN; t = option(COLON; ts = type_sig; { ts }); ARROW; body = expr; { EFunction(args, t, body) }
;

expr
: e = expr_unit; { e }
| e = expr_comp; { e }
;

module_sec
: MODULE; LBRACE; es = separated_list(COMMA, v = var_def; ASSIGN; e = expr; { (v, e) }); RBRACE; { es }
;

main_sec
: MAIN; LBRACE; e = expr; RBRACE; { e }
;

section
: is = import_sec; { ImportSect(is) }
| td = type_def; { TypeSect(td) }
| es = module_sec; { ModuleSect(es) }
| e = main_sec; { MainSect(e) }
;

sections
: { [] }
| s = section; rst = sections; { s :: rst }
;

prog
: ss = sections; EOF; { Program(ss) }
;
