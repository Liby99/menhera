const Func = require('./func');

const Compiler = {
  
  /**
   * Extract all the functions into an function array, at the same time replace all expr_function
   * to expr_closure with function reference
   * @param  {[Node]} ast [description]
   * @return {{ main: Node, functions: [Func]}} funcs [description]
   */
  extractFunctions(ast) {
    
    // Setup functions array
    const functions = [];
    
    // Traverse the ast, extract the visible function and return the processed ast
    const traverse = (node) => node.match({
      'expr_bin_op': ({ type, e1, op, e2 }) => ({ type, op, e1: traverse(e1), e2: traverse(e2) }),
      'expr_let': ({ type, name, binding, expr }) => ({ type, name, binding: traverse(binding), expr: traverse(expr) }),
      'expr_application': ({ type, func, params }) => ({ type, func: traverse(func), params: params.map(traverse) }),
      'expr_function': ({ type, args, body }) => {
        const func = new Func({ type, args, body: traverse(body) }, functions.length);
        return { type: 'expr_closure', func: functions.push(func) }; // Trick: push returns the pushed item
      },
      '_': (node) => node,
    });
    
    // Get the main expression
    const main = traverse(ast);
    return { main, functions };
  }
};

module.exports = Compiler;
