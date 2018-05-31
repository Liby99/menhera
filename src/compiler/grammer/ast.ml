type type_def_sig =
    | UnitTypeDefSig of string
    | GenTypeDefSig of string * string list

type type_sig =
    | UnitTypeSig of string
    | GenTypeSig of string * type_sig list

type ctor_def =
    | UnitCtor of string
    | CompCtor of string * type_sig list

type type_def =
    | TypeDef of type_def_sig * ctor_def list

type import =
    | Import of string
    | ImportAs of string * string

type binop =
    | Plus

type expr =
    | Int of int
    | BinOp of binop * expr * expr

type section =
    | ImportSect of import list
    | TypeSect of type_def
    | MainSect of expr

type prog =
    | Program of section list
