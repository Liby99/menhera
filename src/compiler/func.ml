open Llvm
open Ast

exception MissingReturnTypeError

class func (args : var list) (tyo : typ option) (body : expr) (parent : func option) =
  let typ = match tyo with
    | Some(t) -> t
    | None -> raise MissingReturnTypeError
  in
  object
    val args : var list = args
    val ret_typ : typ = typ
    val body : expr = body
    val parent : func option = parent
  end;;
