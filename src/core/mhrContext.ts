import * as fs from 'fs';
import * as path from 'path';
import Parser from '../parser/parser';
import MhrFunction from './mhrFunction';
import MhrAst from './mhrAst';
import MhrNode from './mhrNode';
import MhrType from './mhrType';

class MhrContext {
  
  filename: string;
  file: string;
  ast: MhrAst;
  functions: { [name: string]: MhrFunction };
  
  constructor(filename: string) {
    
    // Initializing
    this.filename = path.join(process.cwd(), filename);
    this.file = fs.readFileSync(this.filename, 'utf-8');
    
    // Parse
    this.ast = Parser.parse(this.file);
    
    // Preprocessing - get functions including main and other lambda functions
    this.functions = MhrContext.extractFunctions(this.ast);
    Object.keys(this.functions).forEach((key) => this.functions[key].setContext(this));
  }
  
  getFileName(): string {
    return this.filename;
  }
  
  getFile(): string {
    return this.file;
  }
  
  getAst(): MhrAst {
    return this.ast;
  }
  
  getFunctions(): Array<MhrFunction> {
    return Object.keys(this.functions).map((key) => this.functions[key]);
  }
  
  getFunction(name: string): MhrFunction {
    return this.functions[name];
  }
  
  static extractFunctions(ast: MhrAst): { [name: string]: MhrFunction } {
    
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
      'let': ({ type, variable, binding, expr }) => new MhrNode({
        type,
        variable,
        binding: traverse(binding, env),
        expr: traverse(expr, env)
      }),
      'application': ({ type, callee, params }) => new MhrNode({
        type,
        callee: traverse(callee, env),
        params: params.map((param) => traverse(param, env))
      }),
      'function': ({ args, retType, body }) => {
        const name = MhrFunction.generateName();
        const newBody = traverse(body, name);
        const f = new MhrFunction(args, retType, newBody, env, name);
        functions[name] = f;
        return new MhrNode({
          type: 'closure',
          func: f
        });
      },
      '_': (node) => node,
    });
    
    // Get the main function
    const mainName = 'main';
    const mainExpr = traverse(ast.getRootNode(), mainName);
    functions[mainName] = new MhrFunction([], MhrType.int(), mainExpr, undefined, mainName);
    
    // Return functions
    return functions;
  }
}

export default MhrContext;
