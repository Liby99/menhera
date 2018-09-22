import * as llvm from 'llvm-node';
import MhrVar from 'core/mhrVar';
import {
  default as MhrType,
  MhrClosureType
} from 'core/mhrType';
import {
  default as MhrNode,
  MhrBinOpNode,
  MhrLetNode,
  MhrApplicationNode
} from 'core/mhrNode';

export default class MhrFunction {

  static count: number;

  name: string;
  env: string;
  args: Array<MhrVar>;
  retType: MhrType;
  body: MhrNode;
  vars: Array<MhrVar>;
  localVars: Array<MhrVar>;
  closureType: MhrClosureType;

  llFunctionType: llvm.FunctionType;
  llEnvStructType: llvm.StructType;
  llClosureType: llvm.StructType;
  llFunction: llvm.Function;

  constructor(args: Array<MhrVar>, retType: MhrType, body: MhrNode, env: string, name: string) {
    this.name = name;
    this.env = env;
    this.args = args;
    this.retType = retType;
    this.body = body;

    // Preprocessing, get the local variables of this function
    this.vars = MhrFunction.getVariables(this.body);
    this.closureType = new MhrClosureType(retType, args.map(arg => arg.getType()));

    // Cache local vars
    this.localVars = this.args.concat(this.vars);

    // Give env offset to args and vars
    this.args.forEach((a, ai) => a.setIndex(ai));
    this.vars.forEach((v, vi) => v.setIndex(args.length + vi));
  }

  getName(): string {
    return this.name;
  }

  getArgs(): Array<MhrVar> {
    return this.args;
  }

  hasRetType(): boolean {
    return this.retType !== undefined;
  }

  getRetType(): MhrType {
    return this.retType;
  }

  setRetType(retType: MhrType): void {
    this.retType = retType;
  }

  getVars(): Array<MhrVar> {
    return this.vars;
  }

  getLocalVar(name: string): MhrVar {
    return this.args.find((a) => a.name === name) || this.vars.find((v) => v.name === name);
  }

  static generateName(): string {
    return `function_${MhrFunction.count++}`;
  }

  static getVariables(expr: MhrNode): Array<MhrVar> {
    const vars = [];
    const traverse = (node: MhrNode) => node.match({
      'bin_op': ({ e1, e2 }: MhrBinOpNode) => {
        traverse(e1);
        traverse(e2);
      },
      'let': ({ variable, binding, expr }: MhrLetNode) => {
        vars.push(variable);
        traverse(binding);
        traverse(expr);
      },
      'application': ({ callee, params }: MhrApplicationNode) => {
        traverse(callee);
        params.forEach((param) => traverse(param));
      },
    });
    traverse(expr);
    return vars;
  }
}

MhrFunction.count = 0;
