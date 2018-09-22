import * as fs from 'fs';
import * as path from 'path';
import Parser from 'parser/parser';
import MhrFunction from 'core/mhrFunction';
import MhrAst from 'core/mhrAst';
import { default as MhrNode, MhrIntNode, MhrVarNode, MhrBinOpNode, MhrLetNode, MhrFunctionNode, MhrApplicationNode, MhrClosureNode } from 'core/mhrNode';
import { MhrUnitType, MhrTempType, MhrClosureType } from 'core/mhrType';

import print from 'utility/print';

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
    const parser = new Parser(this.file);
    this.ast = parser.parse();
    
    // Preprocessing - type inference
    MhrContext.fillInTypes(this.ast);
    
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
  
  static fillInTypes(ast: MhrAst): void {
    const root = ast.rootNode;
    
    const traverse = (node: MhrNode): void => node.match({
      'int': (node: MhrIntNode) => {
        node.setMhrType(new MhrUnitType('int'));
      },
      'var': (node: MhrVarNode) => {
        if (!node.mhrType) {
          node.setMhrType(new MhrTempType());
        }
      },
      'bin_op': (node: MhrBinOpNode) => {
        const { e1, e2 } = node;
        traverse(e1);
        traverse(e2);
        node.setMhrType(new MhrTempType());
      },
      'let': (node: MhrLetNode) => {
        const { variable, binding, expr } = node;
        
        // Variable type is binding type
        traverse(binding);
        variable.type = binding.mhrType;
        
        // Let expr type is the in-expr type
        traverse(expr);
        node.setMhrType(expr.mhrType);
      },
      'function': (node: MhrFunctionNode) => {
        const { retType, args, body } = node;
        traverse(body);
        if (!retType) {
          node.retType = body.mhrType;
        }
        args.forEach((arg) => {
          if (!arg.hasType()) {
            arg.type = new MhrTempType();
          }
        });
        node.setMhrType(new MhrClosureType(node.retType, args.map(arg => arg.type)));
      },
      'application': (node: MhrApplicationNode) => {
        const { callee, params } = node;
        traverse(callee);
        params.forEach(traverse);
        node.setMhrType(new MhrTempType());
      },
    });
    
    traverse(root);
  }
  
  static extractFunctions(ast: MhrAst): { [name: string]: MhrFunction } {
    
    // Setup functions array
    const functions = {};
    
    // Traverse the ast, extract the visible function and return the processed ast
    const traverse = (node: MhrNode, env: string): MhrNode => node.match({
      'bin_op': ({ e1, op, e2, mhrType }: MhrBinOpNode): MhrNode => {
        return new MhrBinOpNode({ op, e1: traverse(e1, env), e2: traverse(e2, env) }, mhrType);
      },
      'let': ({ variable, binding, expr, mhrType }: MhrLetNode): MhrNode => {
        return new MhrLetNode({
          variable,
          binding: traverse(binding, env),
          expr: traverse(expr, env)
        }, mhrType);
      },
      'application': ({ callee, params, mhrType }: MhrApplicationNode): MhrNode => {
        return new MhrApplicationNode({
          callee: traverse(callee, env),
          params: params.map((param) => traverse(param, env))
        }, mhrType);
      },
      'function': ({ args, retType, body, mhrType }: MhrFunctionNode): MhrNode => {
        const name = MhrFunction.generateName();
        const newBody = traverse(body, name);
        const f = new MhrFunction(args, retType, newBody, env, name);
        functions[name] = f;
        return new MhrClosureNode({ functionName: name }, mhrType);
      },
      '_': (node) => node
    });
    
    // Get the main function
    const mainName = 'main';
    const mainExpr = traverse(ast.getRootNode(), mainName);
    functions[mainName] = new MhrFunction([], new MhrUnitType('int'), mainExpr, undefined, mainName);
    
    // Return functions
    return functions;
  }
}
