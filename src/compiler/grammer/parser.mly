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

/* Type related */
%token TYPE

/* Expr related */

%start <Ast.type_def> type_def

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
