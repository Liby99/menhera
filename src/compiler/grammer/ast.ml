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

type section =
    | ImportSect of import list
    | TypeSect of type_def

type prog =
    | Program of section list
