import MhrVar from 'core/mhrVar';
import MhrType from 'core/mhrType';
import { default as MhrNode, MhrBinOpNode, MhrLetNode, MhrApplicationNode } from 'core/mhrNode';

export default class MhrFunction {
  
  static count: number;
  
  name: string;
  env: string;
  args: Array<MhrVar>;
  retType: MhrType;
  body: MhrNode;
  vars: Array<MhrVar>;
  
  constructor(args, retType, body, env, name) {
    this.name = name;
    this.env = env;
    this.args = args;
    this.retType = retType;
    this.body = body;
    
    // Preprocessing, get the local variables of this function
    this.vars = MhrFunction.getVariables(this.body);
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
