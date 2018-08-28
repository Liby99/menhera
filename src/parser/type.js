// @flow

export type TreeSitterNodePosition = {
  row: number,
  column: number,
};

export type TreeSitterNode = {
  type: string,
  startPosition: TreeSitterNodePosition,
  endPosition: TreeSitterNodePosition,
  childCount: number,
  child: (number) => TreeSitterNode,
};

export type IntNode = {
  type: 'expr_int',
  value: number,
};

export type VarNode = {
  type: 'expr_var',
  name: string,
};

export type BinOpNode = {
  type: 'expr_bin_op',
  e1: MenheraNode,
  e2: MenheraNode,
  op: '+' | '-' | '*' | '/' | '%',
};

export type LetNode = {
  type: 'expr_let',
  name: string,
  binding: MenheraNode,
  expr: MenheraNode,
};

export type FunctionNode = {
  type: 'expr_function',
  args: Array<string>,
  body: MenheraNode,
};

export type ApplicationNode = {
  type: 'expr_application',
  func: MenheraNode,
  params: Array<MenheraNode>
};

export type MenheraNode =
  | IntNode
  | VarNode
  | BinOpNode
  | LetNode
  | FunctionNode
  | ApplicationNode;
