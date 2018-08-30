import * as fs from 'fs';
import * as path from 'path';
import Parser from 'parser/parser';
import MhrFunction from 'core/mhrFunction';
import MhrAst from 'core/mhrAst';
import { default as MhrNode, MhrBinOpNode, MhrLetNode, MhrFunctionNode, MhrApplicationNode, MhrClosureNode } from 'core/mhrNode';
import MhrType from 'core/mhrType';

export default class MhrContext {
  
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
    const traverse = (node: MhrNode, env: string): MhrNode => node.match({
      'bin_op': ({ e1, op, e2 }: MhrBinOpNode): MhrNode => {
        return new MhrBinOpNode({ op, e1: traverse(e1, env), e2: traverse(e2, env) });
      },
      'let': ({ variable, binding, expr }: MhrLetNode): MhrNode => {
        return new MhrLetNode({
          variable,
          binding: traverse(binding, env),
          expr: traverse(expr, env)
        });
      },
      'application': ({ callee, params }: MhrApplicationNode): MhrNode => {
        return new MhrApplicationNode({
          callee: traverse(callee, env),
          params: params.map((param) => traverse(param, env))
        });
      },
      'function': ({ args, retType, body }: MhrFunctionNode): MhrNode => {
        const name = MhrFunction.generateName();
        const newBody = traverse(body, name);
        const f = new MhrFunction(args, retType, newBody, env, name);
        functions[name] = f;
        return new MhrClosureNode({ func: f });
      },
      '_': (node) => node
    });
    
    // Get the main function
    const mainName = 'main';
    const mainExpr = traverse(ast.getRootNode(), mainName);
    functions[mainName] = new MhrFunction([], MhrType.int(), mainExpr, undefined, mainName);
    
    // Return functions
    return functions;
  }
}
