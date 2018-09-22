import MhrVar from 'core/mhrVar';
import MhrType from 'core/mhrType';
import MhrFunction from 'core/mhrFunction';

export type MhrOperator =
  | '+'
  | '-'
  | '*'
  | '/'
  | '%'
  | '_';

export type NodeType =
  | 'int'
  | 'var'
  | 'bin_op'
  | 'let'
  | 'function'
  | 'application'
  | 'closure'
  | '_';

export interface IntNodeData { value: number };
export interface VarNodeData { name: string };
export interface BinOpNodeData { op: MhrOperator, e1: MhrNode, e2: MhrNode };
export interface LetNodeData { variable: MhrVar, binding: MhrNode, expr: MhrNode };
export interface FunctionNodeData { args: Array<MhrVar>, retType: MhrType, body: MhrNode };
export interface ApplicationNodeData { callee: MhrNode, params: Array<MhrNode> };
export interface ClosureNodeData { functionName: string };

export type NodeMatchOptions<T> = { [key in NodeType]?: (node: MhrNode) => T };
export type OperatorMatchOptions<T> = { [key in MhrOperator]?: (node: MhrBinOpNode) => T };

export default class MhrNode {

  mhrType: MhrType;
  type: NodeType;

  constructor(type: NodeType, mhrType?: MhrType) {
    this.type = type;
    this.mhrType = mhrType;
  }

  setMhrType(mhrType: MhrType) {
    this.mhrType = mhrType;
    return mhrType;
  }

  match<U>(options: NodeMatchOptions<U>): U {
    const option = options[this.type] || options['_'];
    return option && option(this);
  }
}

export class MhrIntNode extends MhrNode implements IntNodeData {
  value: number;
  constructor({ value }: IntNodeData, mhrType?: MhrType) {
    super('int', mhrType);
    this.value = value;
  }
}

export class MhrVarNode extends MhrNode implements VarNodeData {
  name: string;
  constructor({ name }: VarNodeData, mhrType?: MhrType) {
    super('var', mhrType);
    this.name = name;
  }
}

export class MhrBinOpNode extends MhrNode implements BinOpNodeData {
  op: MhrOperator;
  e1: MhrNode;
  e2: MhrNode;
  constructor({ op, e1, e2 }: BinOpNodeData, mhrType?: MhrType) {
    super('bin_op', mhrType);
    this.op = op;
    this.e1 = e1;
    this.e2 = e2;
  }

  matchOperator<T>(options: OperatorMatchOptions<T>): T {
    const option = options[this.op];
    if (option) {
      return option(this);
    } else {
      throw new Error(`Operator ${this.op} not found`);
    }
  }
}

export class MhrLetNode extends MhrNode implements LetNodeData {
  variable: MhrVar;
  binding: MhrNode;
  expr: MhrNode;
  constructor({ variable, binding, expr }: LetNodeData, mhrType?: MhrType) {
    super('let', mhrType);
    this.variable = variable;
    this.binding = binding;
    this.expr = expr;
  }
}

export class MhrFunctionNode extends MhrNode implements FunctionNodeData {
  args: Array<MhrVar>;
  retType: MhrType;
  body: MhrNode;
  constructor({ args, retType, body }: FunctionNodeData, mhrType?: MhrType) {
    super('function', mhrType);
    this.args = args;
    this.retType = retType;
    this.body = body;
  }
}

export class MhrApplicationNode extends MhrNode implements ApplicationNodeData {
  callee: MhrNode;
  params: Array<MhrNode>;
  constructor({ callee, params }: ApplicationNodeData, mhrType?: MhrType) {
    super('application', mhrType);
    this.callee = callee;
    this.params = params;
  }
}

export class MhrClosureNode extends MhrNode implements ClosureNodeData {
  functionName: string;
  constructor({ functionName }: ClosureNodeData, mhrType?: MhrType) {
    super('closure', mhrType);
    this.functionName = functionName;
  }
}
