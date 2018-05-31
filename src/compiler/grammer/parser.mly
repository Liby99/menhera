%{ open Ast %}

/* Variables */
%token <int> INT
%token <string> ID

/* General Symbols */
%token LPAREN
%token RPAREN
%token LBRACKET
%token RBRACKET
%token LBRACE
%token RBRACE
%token LANGLE
%token RANGLE
%token COMMA
%token SEMICOLON
%token EOF

/* Computation Symbols */
%token PLUS

/* Section related */
%token IMPORT
%token AS
%token TYPE
%token MAIN

/* Expr related */

%left PLUS

%start <Ast.prog> prog

%%

import:
    | m = ID; AS; name = ID; { ImportAs(m, name) }
    | name = ID; { Import(name) }
;

import_sec:
    | IMPORT; LBRACE; is = separated_list(COMMA, import); RBRACE; { is }
;

type_def_sig:
    | name = ID; LANGLE; gs = separated_list(COMMA, ID); RANGLE; { GenTypeDefSig(name, gs) }
    | name = ID; { UnitTypeDefSig(name) }
;

type_sig:
    | name = ID; LANGLE; tss = separated_list(COMMA, type_sig); RANGLE; { GenTypeSig(name, tss) }
    | name = ID; { UnitTypeSig(name) }
;

ctor:
    | name = ID; LPAREN; tss = separated_list(COMMA, type_sig); RPAREN; { CompCtor(name, tss) }
    | name = ID; { UnitCtor(name) }
;

type_def:
    | TYPE; tds = type_def_sig; LBRACE; ctors = separated_list(COMMA, ctor); RBRACE; { TypeDef(tds, ctors) }
;

expr:
    | i = INT { Int(i) }
    | e1 = expr; PLUS; e2 = expr; { BinOp(Plus, e1, e2) }
;

main_sec:
    | MAIN; LBRACE; e = expr; RBRACE; { e }
;

section:
    | is = import_sec; { ImportSect(is) }
    | td = type_def; { TypeSect(td) }
    | e = main_sec; { MainSect(e) }
;

sections:
    | { [] }
    | s = section; rst = sections; { s :: rst }
;

prog:
    | ss = sections; EOF; { Program(ss) }
;
