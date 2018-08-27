module Syntax where

type Name = String

data Expr
  = Integer Int
  | Var String
  | BinOp Op Expr Expr
  | Function [String] Expr
  | Call Expr [Expr]
  deriving (Eq, Ord, Show)

data Op
  = Plus
  | Minus
  deriving (Eq, Ord, Show)
