const Assert = require('assert');

class Func {
  constructor(node, funcIndex) {
    const { type, args, body } = node;
    Assert.equal(type, 'expr_function', 'Expect the node to be a expr_function');
    
    // Setup self
    this.funcIndex = funcIndex;
    this.args = args;
    this.body = body;
  }
}

module.exports = Func;
