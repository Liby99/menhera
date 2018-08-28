const Assert = require('assert');

class Func {
  constructor(node, funcIndex) {
    const { type, args, body } = node;
    Assert.equal(type, 'function', 'Expect the node to be an expr_function');
    
    // Setup self
    this.funcIndex = funcIndex;
    this.funcName = Func.generateFunctionName(funcIndex);
    this.args = args;
    this.body = body;
  }
  
  static generateFunctionName(index) {
    return `function_${index}`;
  }
}

module.exports = Func;
