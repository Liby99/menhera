const Func = {
  
  /**
   * Extract all the functions into an function array, at the same time replace all expr_function
   * to expr_closure with function reference
   * @param  {[Node]} ast [description]
   * @return {[Array<FunctionNode>]} funcs [description]
   */
  extract(ast) {
    
    // Setup functions array
    const functions = [];
    
    // Traverse the ast
    const traverse = (node) => node.match({
      'expr_bin_op': ({ type, data: { e1, op, e2 } }) => ({
        type,
        data: {
          op,
          e1: traverse(e1),
          e2: traverse(e2),
        }
      }),
      'expr_let': ({ type, data: { name, binding, expr } }) => ({
        name,
        binding: traverse(binding),
        expr: traverse(expr),
      }),
      'expr_function': ({ type, data: { args, body }}) => {
        const processedBody = traverse(body);
        const newNode = { type, data: { args, body: processedBody }};
        functions.push(newNode);
        return {
          type: 'expr_closure',
          data: {
            funcIndex: functions.length - 1,
          },
        };
      },
      'expr_application': ({ type, data: { func, params }}) => ({
        type,
        data: {
          func: traverse(func),
          params: params.map(traverse),
        },
      }),
      '_': (node) => node,
    });
    const mainExpr = traverse(ast);
  }
};

module.exports = Func;
