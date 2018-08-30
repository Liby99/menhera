import * as TreeSitter from 'tree-sitter';
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

function parseNode(tsNode: TreeSitter.SyntaxNode, fileContext: FileContext): MhrNode {
  return getNode(getRealNode(tsNode), fileContext);
}

function parseVar(tsNode: TreeSitter.SyntaxNode, fileContext: FileContext): MhrVar {
  const child = tsNode.child(0);
  const hasType = child.type === 'typed_var';
  const name = fileContext.get(child.child(0));
  const type = hasType ? parseType(child.child(2), fileContext) : undefined;
  return new MhrVar(name, type);
}

function parseType(tsNode: TreeSitter.SyntaxNode, fileContext: FileContext): MhrType {
  const child = tsNode.child(0);
  switch (child.type) {
    case 'unit_type':
      return new MhrType('unit', {
        name: fileContext.get(child.child(0)),
      });
    case 'function_type':
      return new MhrType('function', {
        args: getList(child.child(1)).map((n) => parseType(n, fileContext)),
        ret: parseType(child.child(4), fileContext),
      });
    default:
      throw new Error(`Unknown type ${child.type}`);
  }
}

function parseOperator(tsNode: TreeSitter.SyntaxNode): MhrOperator {
  const { type } = tsNode;
  switch (type) {
    case '+':
    case '-':
    case '*':
    case '/':
    case '%':
      return type;
    default:
      throw new Error(`Unknown operator ${type}`);
  }
}

function getRealNode(tsNode: TreeSitter.SyntaxNode): TreeSitter.SyntaxNode {
  const { type } = tsNode;
  if (type.indexOf(PREFIX) === 0) {
    return tsNode;
  } else {
    const childIndex = type === 'paren_expr' ? 1 : 0;
    return getRealNode(tsNode.child(childIndex));
  }
}

function getNode(tsNode: TreeSitter.SyntaxNode, fileContext: FileContext): MhrNode {
  const { type } = tsNode;
  return getDataGetter(type)(tsNode, fileContext);
}

function getDataGetter(type: string): (n: TreeSitter.SyntaxNode, fc: FileContext) => MhrNode {
  switch (type) {
    case 'expr_int': return getIntData;
    case 'expr_var': return getVarData;
    case 'expr_bin_op': return getBinOpData;
    case 'expr_let': return getLetData;
    case 'expr_function': return getFunctionData;
    case 'expr_application': return getApplicationData;
    default: throw new Error(`Not implemented type ${type}`);
  }
}

function getIntData(tsNode: TreeSitter.SyntaxNode, fileContext: FileContext): MhrIntNode {
  const integerNode = tsNode.child(0);
  const integerStr = fileContext.get(integerNode);
  const value = parseInt(integerStr);
  return new MhrIntNode({ value });
}

function getVarData(tsNode: TreeSitter.SyntaxNode, fileContext: FileContext): MhrVarNode {
  const identifierNode = tsNode.child(0);
  const name = fileContext.get(identifierNode);
  return new MhrVarNode({ name });
}

function getBinOpData(tsNode: TreeSitter.SyntaxNode, fileContext: FileContext): MhrBinOpNode {
  const e1 = parseNode(tsNode.child(0), fileContext);
  const op = parseOperator(tsNode.child(1));
  const e2 = parseNode(tsNode.child(2), fileContext);
  return new MhrBinOpNode({ op, e1, e2 });
}

function getLetData(tsNode: TreeSitter.SyntaxNode, fileContext: FileContext): MhrLetNode {
  const variable = parseVar(tsNode.child(1), fileContext);
  const binding = parseNode(tsNode.child(3), fileContext);
  const expr = parseNode(tsNode.child(5), fileContext);
  return new MhrLetNode({ variable, binding, expr });
}

function getFunctionData(tsNode: TreeSitter.SyntaxNode, fileContext: FileContext): MhrFunctionNode {
  const args = getList(tsNode.child(1)).map((n) => parseVar(n, fileContext));
  const body = parseNode(tsNode.child(tsNode.childCount - 1), fileContext);
  const hasRetType = tsNode.childCount === 7;
  const retType = hasRetType ? parseType(tsNode.child(4), fileContext) : undefined;
  return new MhrFunctionNode({ args, retType, body });
}

function getApplicationData(tsNode: TreeSitter.SyntaxNode, fileContext: FileContext): MhrApplicationNode {
  const callee = parseNode(tsNode.child(0), fileContext);
  const params = getList(tsNode.child(2)).map((n) => parseNode(n, fileContext));
  return new MhrApplicationNode({ callee, params });
}

function getList(tsNode: TreeSitter.SyntaxNode): Array<TreeSitter.SyntaxNode> {
  const elem = [tsNode.child(0)];
  const comma = tsNode.child(1);
  return comma ? elem.concat(getList(tsNode.child(2))) : elem;
}

const Parser = {
  parse(file: string): MhrAst {
    
    // Setup tree-sitter parser and Use tree-sitter parser to parse the file
    const TreeSitterParser = new TreeSitter();
    TreeSitterParser.setLanguage(Menhera);
    const tsTree: TreeSitter.Tree = TreeSitterParser.parse(file);
    const tsRootNode: TreeSitter.SyntaxNode = tsTree.rootNode;
    
    // Further process the file to get the real AST
    const fileContext = new FileContext(file);
    return new MhrAst(parseNode(tsRootNode, fileContext));
  }
}

export default Parser;
