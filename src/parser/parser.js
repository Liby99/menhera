const TreeSitter = require('tree-sitter');
const TreeSitterMenhera = require('tree-sitter-menhera');
const FileContext = require('parser/fileContext');
const MhrAst = require('core/mhrAst');
const MhrNode = require('core/mhrNode');

const PREFIX = 'expr_';

function parseNode(tsNode, fileContext) {
  
  // Get the node with real meaning
  const node = getRealNode(tsNode);
  const type = node.type.substring(PREFIX.length);
  
  // Get data and copy all things to self
  const data = getData(node, fileContext);
  return new MhrNode({ type, ...data });
}

function getRealNode(tsNode) {
  const { type } = tsNode;
  if (type.indexOf(PREFIX) === 0) {
    return tsNode;
  } else {
    const childIndex = type === 'paren_expr' ? 1 : 0;
    return getRealNode(tsNode.child(childIndex));
  }
}

function getData(tsNode, fileContext) {
  const { type } = tsNode;
  return getDataGetter(type)(tsNode, fileContext);
}

function getDataGetter(type) {
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

function getIntData(tsNode, fileContext) {
  const integerNode = tsNode.child(0);
  const integerStr = fileContext.get(integerNode);
  const value = parseInt(integerStr);
  return { value };
}

function getVarData(tsNode, fileContext) {
  const identifierNode = tsNode.child(0);
  const name = fileContext.get(identifierNode);
  return { name };
}

function getBinOpData(tsNode, fileContext) {
  const e1 = parseNode(tsNode.child(0), fileContext);
  const op = tsNode.child(1).type;
  const e2 = parseNode(tsNode.child(2), fileContext);
  return { op, e1, e2 };
}

function getLetData(tsNode, fileContext) {
  const name = fileContext.get(tsNode.child(1));
  const binding = parseNode(tsNode.child(3), fileContext);
  const expr = parseNode(tsNode.child(5), fileContext);
  return { name, binding, expr };
}

function getFunctionData(tsNode, fileContext) {
  const args = getList(tsNode.child(1)).map((n) => fileContext.get(n));
  const body = parseNode(tsNode.child(4), fileContext);
  return { args, body };
}

function getApplicationData(tsNode, fileContext) {
  const callee = parseNode(tsNode.child(0), fileContext);
  const params = getList(tsNode.child(2)).map((n) => parseNode(n, fileContext));
  return { callee, params };
}

function getList(tsNode) {
  const elem = [tsNode.child(0)];
  const comma = tsNode.child(1);
  return comma ? elem.concat(getList(tsNode.child(2))) : elem;
}

const Parser = {
  parse(file) {
    
    // Setup tree-sitter parser and Use tree-sitter parser to parse the file
    const TreeSitterParser = new TreeSitter();
    TreeSitterParser.setLanguage(TreeSitterMenhera);
    const tsTree = TreeSitterParser.parse(file);
    const tsRootNode = tsTree.rootNode;
    
    // Further process the file to get the real AST
    const fileContext = new FileContext(file);
    return new MhrAst(tsTree, parseNode(tsRootNode, fileContext));
  }
}

module.exports = Parser;
