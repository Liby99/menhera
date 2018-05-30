type type_def_sig =
    | TypeDefSig of string * string list

type type_sig =
    | TypeSig of string * type_sig list

type ctor_def =
    | CtorDef of string * type_sig list

type type_def =
    | TypeDef of type_def_sig * ctor_def list

type section =
    | TypeSection of type_def

type prog =
    | Program of section list
