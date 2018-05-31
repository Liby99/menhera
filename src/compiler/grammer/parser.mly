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

type_sig:
    | name = ID; { TypeSig(name, []) }
    | name = ID; LANGLE; tss = separated_list(COMMA, type_sig); RANGLE; { TypeSig(name, tss) }
;

type_def_sig:
    | name = ID; { TypeDefSig(name, []) }
    | name = ID; LANGLE; gs = separated_list(COMMA, ID); RANGLE; { TypeDefSig(name, gs) }
;

ctor:
    | name = ID; { CtorDef(name, []) }
    | name = ID; LPAREN; tss = separated_list(COMMA, type_sig); RPAREN; { CtorDef(name, tss) }
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
    | td = type_def; { TypeSection(td) }
    | is = import_sec; { ImportSection(is) }
;

sections:
    | { [] }
    | s = section; rst = sections; { s :: rst }
;

prog:
    | ss = sections; EOF; { Program(ss) }
;
