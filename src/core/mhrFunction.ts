import MhrVar from './mhrVar';
import MhrType from './mhrType';
import MhrNode from './mhrNode';
import MhrContext from './mhrContext';

class MhrFunction {
  
  static count: number;
  
  name: string;
  env: string;
  args: Array<MhrVar>;
  retType: MhrType;
  body: MhrNode;
  vars: Array<MhrVar>;
  context: MhrContext;
  
  constructor(args, retType, body, env, name) {
    this.name = name;
    this.env = env;
    this.args = args;
    this.retType = retType;
    this.body = body;
    
    // Preprocessing, get the local variables of this function
    this.vars = MhrFunction.getVariables(this.body);
  }
  
  setContext(mhrContext) {
    this.context = mhrContext;
  }
  
  getArgs() {
    return this.args;
  }
  
  hasRetType() {
    return this.retType !== undefined;
  }
  
  getRetType() {
    return this.retType;
  }
  
  setRetType(retType) {
    this.retType = retType;
  }
  
  getName() {
    return this.name;
  }
  
  static generateName() {
    return `function_${MhrFunction.count++}`;
  }
  
  static getVariables(expr) {
    const vars = [];
    const traverse = (node) => node.match({
      'bin_op': ({ e1, e2 }) => {
        traverse(e1);
        traverse(e2);
      },
      'let': ({ variable, binding, expr }) => {
        vars.push(variable);
        traverse(binding);
        traverse(expr);
      },
      'application': ({ callee, params }) => {
        traverse(callee);
        params.forEach((param) => traverse(param));
      },
    });
    traverse(expr);
    return vars;
  }
}

MhrFunction.count = 0;

export default MhrFunction;