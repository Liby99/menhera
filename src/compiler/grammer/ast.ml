type type_def_sig =
    | UnitTypeDefSig of string
    | GenTypeDefSig of string * string list

and type_sig =
    | UnitTypeSig of string
    | GenTypeSig of string * type_sig list
    | FuncTypeSig of type_sig list * type_sig
    | ListTypeSig of type_sig

and ctor_def =
    | UnitCtor of string
    | CompCtor of string * type_sig list

and type_def =
    | TypeDef of type_def_sig * ctor_def list

and import =
    | Import of string
    | ImportAs of string * string

and var_def =
    | Var of string
    | VarWithType of string * type_sig

and binop =
    | Plus
    | Minus
    | Times
    | Divide
    | Mod
    | And
    | Or
    | Equal
    | Inequal
    | Greater
    | GreaterOrEqual
    | Less
    | LessOrEqual
    | ListGet

and unaop =
    | Not
    | Neg
    | Str
    | Len

and binding =
    | Binding of var_def * expr

and pattern =
    | PatWildCard
    | PatId of string
    | PatModuleId of string * string
    | PatInt of int
    | PatBool of bool
    | PatFloat of float
    | PatString of string
    | PatList of pattern list
    | PatApp of pattern * pattern list

and expr =
    | Id of string
    | ModuleId of string * string
    | Int of int
    | Bool of bool
    | Float of float
    | String of string
    | List of expr list
    | BinOp of binop * expr * expr
    | UnaOp of unaop * expr
    | Let of binding list * expr
    | If of expr * expr * expr
    | Match of expr * (pattern * expr) list
    | Function of var_def list * type_sig option * expr
    | App of expr * expr list

and section =
    | ImportSect of import list
    | TypeSect of type_def
    | ModuleSect of (var_def * expr) list
    | MainSect of expr

and prog =
    | Program of section list
