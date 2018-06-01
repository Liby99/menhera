type type_def_sig =
    | UnitTypeDefSig of string
    | GenTypeDefSig of string * string list

and type_sig =
    | UnitTypeSig of string
    | GenTypeSig of string * type_sig list
    | FuncTypeSig of type_sig list * type_sig

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
    | And
    | Or
    | Equal
    | Inequal
    | Greater
    | GreaterOrEqual
    | Less
    | LessOrEqual

and unaop =
    | Not
    | Neg
    | Str

and binding =
    | Binding of var_def * expr

and expr =
    | Int of int
    | Bool of bool
    | Id of string
    | BinOp of binop * expr * expr
    | UnaOp of unaop * expr
    | Let of binding list * expr
    | If of expr * expr * expr
    | Function of var_def list * type_sig option * expr
    | App of expr * expr list

and section =
    | ImportSect of import list
    | TypeSect of type_def
    | MainSect of expr

and prog =
    | Program of section list
