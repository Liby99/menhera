const Func = require('./func');

const Compiler = {
  extractFunctions(ast) {
    
    // Setup functions array
    const functions = [];
    
    // Traverse the ast, extract the visible function and return the processed ast
    const traverse = (node) => node.match({
      'bin_op': ({ type, e1, op, e2 }) => ({ type, op, e1: traverse(e1), e2: traverse(e2) }),
      'let': ({ type, name, binding, expr }) => ({ type, name, binding: traverse(binding), expr: traverse(expr) }),
      'application': ({ type, callee, params }) => ({ type, callee: traverse(callee), params: params.map(traverse) }),
      'function': ({ type, args, body }) => {
        const func = new Func({ type, args, body: traverse(body) }, functions.length);
        functions.push(func);
        return { type: 'closure', func };
      },
      '_': (node) => node,
    });
    
    // Get the main expression
    const main = traverse(ast);
    return { main, functions };
  },
  
  compile(ast) {
    
    // First extract all functions
    const { main, functions } = Compiler.extractFunctions(ast);
  }
};

module.exports = Compiler;
