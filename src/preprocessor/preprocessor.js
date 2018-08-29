const MhrFunction = require('core/mhrFunction');

const Preprocessor = {
  extractFunctions(ast) {
    
    // Setup functions array
    const functions = [];
    
    // Traverse the ast, extract the visible function and return the processed ast
    const traverse = (node) => node.match({
      'bin_op': ({ type, e1, op, e2 }) => ({
        type,
        op,
        e1: traverse(e1),
        e2: traverse(e2)
      }),
      'let': ({ type, name, binding, expr }) => ({
        type,
        name,
        binding: traverse(binding),
        expr: traverse(expr)
      }),
      'application': ({ type, callee, params }) => ({
        type,
        callee: traverse(callee),
        params: params.map(traverse)
      }),
      'function': ({ type, args, body }) => {
        const fId = functions.length;
        const f = new MhrFunction(type, args, traverse(body), fId);
        functions.push(f);
        return {
          type: 'closure',
          func: f
        };
      },
      '_': (node) => node,
    });
    
    // Get the main expression
    const mainExpr = traverse(ast.getRoot());
    return { mainExpr, functions };
  }
};

module.exports = Preprocessor;
