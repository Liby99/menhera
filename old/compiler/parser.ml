open Str

let to_token_list (str : string) : string list =
    Str.full_split (Str.regexp "\\s")
    |> List.filter ~f:(fun x -> x <> "")
    |> List.map ~f:(fun s ->
        String.split_on_chars ~on:['+'; '-'; '*'; '/'] s)

let parse (str : string) : expr =
    let tok_ls = to_token_list str in
    

(* type token =
    | TNum of int
    | TBool of bool
    | TFloat of float
    | TId of string
    | TChar of char
    | TString of string
    | TSemicolon
    | TAssign
    | TLParen
    | TRParen
    | TComma
    | TFatArrow
    | TLBracket
    | TRBracket
    | TLBrace
    | TRBrace
    | TOp2 of op2
    | TOp1 of op1
    | TMatch
    | TEOF
;;

type op2 =
    | OAdd
    | OSub
    | OMul
    | ODiv
    | OEq
    | OGt
    | OLt
    | OGte
    | OLte
    | OAnd
    | OOr
    | OBitAnd
    | OBitOr
    | OBitXor
    | OConcat
;;

type op1 =
    | ONot
    | OBitNot
    | OInc
    | ODec
;;

 *)
