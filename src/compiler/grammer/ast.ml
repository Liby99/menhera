type id =
    | Id of string
    | ModuleId of string * string

and type_def_sig =
    | UnitTypeDefSig of string
    | GenTypeDefSig of string * string list

and type_sig =
    | UnitTypeSig of id
    | GenTypeSig of id * type_sig list
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
    | ImportAll of string
    | ImportMember of string * string list
    | ImportHiding of string * string list

and var_def =
    | Var of string
    | VarWithType of string * type_sig
    | Operator of operator
    | OperatorWithType of operator * type_sig

and operator =
    | OperatorBin of binop
    | OperatorUna of unaop

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

and pattern =
    | PWildCard
    | PId of id
    | PInt of int
    | PBool of bool
    | PFloat of float
    | PString of string
    | PList of pattern list
    | PApp of pattern * pattern list

and expr =
    | EId of id
    | EInt of int
    | EBool of bool
    | EFloat of float
    | EString of string
    | EList of expr list
    | EBinOp of binop * expr * expr
    | EUnaOp of unaop * expr
    | ELet of (var_def * expr) list * expr
    | EIf of expr * expr * expr
    | EMatch of expr * (pattern * expr) list
    | EFunction of var_def list * type_sig option * expr
    | EApp of expr * expr list

and section =
    | ImportSect of import list
    | TypeSect of type_def
    | ModuleSect of (var_def * expr) list
    | MainSect of expr

and prog =
    | Program of section list
