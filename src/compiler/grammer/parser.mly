%{ open Ast %}

/* Variables */
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

/* Section related */
%token TYPE
%token IMPORT

/* Expr related */

%start <Ast.prog> prog

%%

type_def_sig:
    | name = ID; { UnitTypeDefSig(name) }
    | name = ID; LANGLE; gs = separated_list(COMMA, ID); RANGLE; { GenTypeDefSig(name, gs) }
;

type_sig:
    | name = ID; { UnitTypeSig(name) }
    | name = ID; LANGLE; tss = separated_list(COMMA, type_sig); RANGLE; { GenTypeSig(name, tss) }
;

ctor:
    | name = ID; { UnitCtor(name) }
    | name = ID; LPAREN; tss = separated_list(COMMA, type_sig); RPAREN; { CompCtor(name, tss) }
;

type_def:
    | TYPE; tds = type_def_sig; LBRACE; ctors = separated_list(COMMA, ctor); RBRACE; { TypeDef(tds, ctors) }
;

import:
    | name = ID; { Import(name) }
;

import_sec:
    | IMPORT; LBRACE; is = separated_list(COMMA, import); RBRACE; { is }
;

section:
    | is = import_sec; { ImportSect(is) }
    | td = type_def; { TypeSect(td) }
;

sections:
    | { [] }
    | s = section; rst = sections; { s :: rst }
;

prog:
    | ss = sections; EOF; { Program(ss) }
;
