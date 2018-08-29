const MhrVar = require('core/mhrVar');

class MhrFunction {
  constructor(args, body, env, funcName) {
    this.name = funcName;
    this.env = env;
    this.args = args;
    this.body = body;
    this.vars = MhrFunction.getVariables(this.body);
  }
  
  setContext(mhrContext) {
    this.context = mhrContext;
  }
  
  getName() {
    return this.funcName;
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
      'let': ({ name, binding, expr }) => {
        vars.push(new MhrVar(name));
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

module.exports = MhrFunction;
