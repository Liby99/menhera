const MhrFunction = require('core/mhrFunction');
const MhrNode = require('core/mhrNode');

const Preprocessor = {
  extractFunctions(ast) {
    
    // Setup functions array
    const functions = {};
    
    // Traverse the ast, extract the visible function and return the processed ast
    const traverse = (node, env) => node.match({
      'bin_op': ({ type, e1, op, e2 }) => new MhrNode({
        type,
        op,
        e1: traverse(e1, env),
        e2: traverse(e2, env)
      }),
      'let': ({ type, name, binding, expr }) => new MhrNode({
        type,
        name,
        binding: traverse(binding, env),
        expr: traverse(expr, env)
      }),
      'application': ({ type, callee, params }) => new MhrNode({
        type,
        callee: traverse(callee, env),
        params: params.map((param) => traverse(param, env))
      }),
      'function': ({ args, body }) => {
        const name = MhrFunction.generateName();
        const newBody = traverse(body, name);
        const f = new MhrFunction(args, newBody, env, name);
        functions[name] = f;
        return new MhrNode({
          type: 'closure',
          func: f
        });
      },
      '_': (node) => node,
    });
    
    // Get the main function
    const mainExpr = traverse(ast.getRootNode(), 'main');
    functions['main'] = new MhrFunction([], mainExpr, undefined, 'main');
    
    // Return functions
    return functions;
  }
};

module.exports = Preprocessor;
