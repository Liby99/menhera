const fs = require('fs');
const path = require('path');
const Parser = require('parser/parser');
const MhrFunction = require('core/mhrFunction');
const MhrNode = require('core/mhrNode');

class MhrContext {
  constructor(filename) {
    
    // Initializing
    this.filename = path.join(process.cwd(), filename);
    this.file = fs.readFileSync(this.filename, 'utf-8');
    
    // Parse
    this.ast = Parser.parse(this.file);
    
    // Preprocessing - get functions including main and other lambda functions
    this.functions = MhrContext.extractFunctions(this.ast);
    Object.keys(this.functions).forEach((key) => this.functions[key].setContext(this));
  }
  
  getFileName() {
    return this.filename;
  }
  
  getFile() {
    return this.file;
  }
  
  getAst() {
    return this.ast;
  }
  
  getFunctions() {
    return this.functions;
  }
  
  getFunction(name) {
    return this.functions[name];
  }
  
  static extractFunctions(ast) {
    
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
}

module.exports = MhrContext;
