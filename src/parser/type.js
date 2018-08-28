// @flow

type TreeSitterNodePosition = {
  row: number,
  column: number,
};

type TreeSitterNode = {
  type: string,
  startPosition: TreeSitterNodePosition,
  endPosition: TreeSitterNodePosition,
  childCount: number,
  child: (number) => TreeSitterNode,
};

export type { TreeSitterNodePosition, TreeSitterNode };

type IntNode = {
  type: 'expr_int',
  data: number,
};

type VarNode = {
  type: 'expr_var',
  data: string,
};

type BinOpNode = {
  type: 'expr_bin_op',
  data: {
    e1: MenheraNode,
    e2: MenheraNode,
    op: '+' | '-' | '*' | '/' | '%',
  },
};

type LetNode = {
  type: 'expr_let',
  data: {
    name: string,
    binding: MenheraNode,
    expr: MenheraNode,
  },
};

type FunctionNode = {
  type: 'expr_function',
  data: {
    args: Array<string>,
    body: MenheraNode,
  },
};

type ApplicationNode = {
  type: 'expr_application',
  data: {
    func: MenheraNode,
    params: Array<MenheraNode>
  },
};

type MenheraNode =
  | IntNode
  | VarNode
  | BinOpNode
  | LetNode
  | FunctionNode
  | ApplicationNode;

export type {
  IntNode,
  VarNode,
  BinOpNode,
  LetNode,
  FunctionNode,
  ApplicationNode,
  MenheraNode,
};
