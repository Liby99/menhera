import * as TreeSitter from 'tree-sitter';
import { SyntaxNode, Tree } from 'tree-sitter';
import * as Menhera from 'tree-sitter-menhera';
import FileContext from 'parser/fileContext';
import MhrAst from 'core/mhrAst';
import {
  default as MhrNode,
  MhrIntNode,
  MhrVarNode,
  MhrBinOpNode,
  MhrLetNode,
  MhrFunctionNode,
  MhrApplicationNode,
} from 'core/mhrNode';
import MhrVar from 'core/mhrVar';
import MhrType from 'core/mhrType';

const PREFIX = 'expr_';

export default class Parser {
  
  tsTree: Tree;
  fileContext: FileContext;
  
  constructor(file: string) {
    const TreeSitterParser = new TreeSitter();
    TreeSitterParser.setLanguage(Menhera);
    this.tsTree = TreeSitterParser.parse(file);
    this.fileContext = new FileContext(file);
  }
  
  parse(): MhrAst {
    const tsRootNode: SyntaxNode = this.tsTree.rootNode;
    return new MhrAst(this.parseNode(tsRootNode));
  }
  
  parseNode(tsNode: SyntaxNode): MhrNode {
    return this.getMhrNode(this.getRealNode(tsNode));
  }
  
  parseVar(tsNode: SyntaxNode): MhrVar {
    const child = tsNode.child(0);
    const hasType = child.type === 'typed_var';
    const name = this.fileContext.get(child.child(0));
    const type = hasType ? this.parseType(child.child(2)) : undefined;
    return new MhrVar(name, type);
  }
  
  parseType(tsNode: SyntaxNode): MhrType {
    const child = tsNode.child(0);
    switch (child.type) {
      case 'unit_type':
        return new MhrType('unit', {
          name: this.fileContext.get(child.child(0)),
        });
      case 'function_type':
        return new MhrType('function', {
          args: this.getList(child.child(1)).map((n) => this.parseType(n)),
          ret: this.parseType(child.child(4)),
        });
      default:
        throw new Error(`Unknown type ${child.type}`);
    }
  }
  
  parseOperator(tsNode: SyntaxNode): MhrOperator {
    const { type } = tsNode;
    switch (type) {
      case '+': case '-': case '*': case '/': case '%': return type;
      default: throw new Error(`Unknown operator ${type}`);
    }
  }
  
  getMhrNode(tsNode: SyntaxNode): MhrNode {
    const { type } = tsNode;
    switch (type) {
      case 'expr_int': return this.getIntNode(tsNode);
      case 'expr_var': return this.getVarNode(tsNode);
      case 'expr_bin_op': return this.getBinOpNode(tsNode);
      case 'expr_let': return this.getLetNode(tsNode);
      case 'expr_function': return this.getFunctionNode(tsNode);
      case 'expr_application': return this.getApplicationNode(tsNode);
      default: throw new Error(`Not implemented type ${type}`);
    }
  }
  
  getRealNode(tsNode: SyntaxNode): SyntaxNode {
    const { type } = tsNode;
    if (type.indexOf(PREFIX) === 0) {
      return tsNode;
    } else {
      const childIndex = type === 'paren_expr' ? 1 : 0;
      return this.getRealNode(tsNode.child(childIndex));
    }
  }
  
  getIntNode(tsNode: SyntaxNode): MhrIntNode {
    const integerNode = tsNode.child(0);
    const integerStr = this.fileContext.get(integerNode);
    const value = parseInt(integerStr);
    return new MhrIntNode({ value });
  }
  
  getVarNode(tsNode: SyntaxNode): MhrVarNode {
    const identifierNode = tsNode.child(0);
    const name = this.fileContext.get(identifierNode);
    return new MhrVarNode({ name });
  }
  
  getBinOpNode(tsNode: SyntaxNode): MhrBinOpNode {
    const e1 = this.parseNode(tsNode.child(0));
    const op = this.parseOperator(tsNode.child(1));
    const e2 = this.parseNode(tsNode.child(2));
    return new MhrBinOpNode({ op, e1, e2 });
  }
  
  getLetNode(tsNode: SyntaxNode): MhrLetNode {
    const variable = this.parseVar(tsNode.child(1));
    const binding = this.parseNode(tsNode.child(3));
    const expr = this.parseNode(tsNode.child(5));
    return new MhrLetNode({ variable, binding, expr });
  }
  
  getFunctionNode(tsNode: SyntaxNode): MhrFunctionNode {
    const args = this.getList(tsNode.child(1)).map((n) => this.parseVar(n));
    const body = this.parseNode(tsNode.child(tsNode.childCount - 1));
    const hasRetType = tsNode.childCount === 7;
    const retType = hasRetType ? this.parseType(tsNode.child(4)) : undefined;
    return new MhrFunctionNode({ args, retType, body });
  }
  
  getApplicationNode(tsNode: SyntaxNode): MhrApplicationNode {
    const callee = this.parseNode(tsNode.child(0));
    const params = this.getList(tsNode.child(2)).map((n) => this.parseNode(n));
    return new MhrApplicationNode({ callee, params });
  }
  
  getList(tsNode: SyntaxNode): Array<SyntaxNode> {
    const elem = [tsNode.child(0)];
    const comma = tsNode.child(1);
    return comma ? elem.concat(this.getList(tsNode.child(2))) : elem;
  }
}
