class Node {
  constructor(tsNode, context) {
    const node = Node.getRealNode(tsNode);
    this.type = node.type;
    this.data = Node.getData(node, context);
  }
  
  match(options) {
    const option = options[this.type] || options['_'];
    return option && option(this);
  }
  
  static getRealNode(tsNode) {
    const { type } = tsNode;
    if (type.indexOf('expr_') === 0) {
      return tsNode;
    } else {
      const childIndex = type === 'paren_expr' ? 1 : 0;
      return Node.getRealNode(tsNode.child(childIndex));
    }
  }
  
  static getData(tsNode, context) {
    const { type } = tsNode;
    const dataFunction = Node.getDataGetter(type);
    return dataFunction(tsNode, context);
  }
  
  static getDataGetter(type) {
    switch (type) {
      case 'expr_int': return Node.getIntData;
      case 'expr_var': return Node.getVarData;
      case 'expr_bin_op': return Node.getBinOpData;
      case 'expr_let': return Node.getLetData;
      case 'expr_function': return Node.getFunctionData;
      case 'expr_application': return Node.getApplicationData;
      default: throw new Error(`Not implemented type ${type}`);
    }
  }
  
  static getIntData(tsNode, context) {
    const integerNode = tsNode.child(0);
    const integerStr = context.get(integerNode);
    const integer = parseInt(integerStr);
    return integer;
  }
  
  static getVarData(tsNode, context) {
    const identifierNode = tsNode.child(0);
    const identifierString = context.get(identifierNode);
    return identifierString;
  }
  
  static getBinOpData(tsNode, context) {
    const e1 = new Node(tsNode.child(0), context);
    const op = tsNode.child(1).type;
    const e2 = new Node(tsNode.child(2), context);
    return { op, e1, e2 };
  }
  
  static getLetData(tsNode, context) {
    const name = context.get(tsNode.child(1));
    const binding = new Node(tsNode.child(3), context);
    const expr = new Node(tsNode.child(5), context);
    return { name, binding, expr };
  }
  
  static getFunctionData(tsNode, context) {
    const args = Node.getList(tsNode.child(1)).map((n) => context.get(n));
    const body = new Node(tsNode.child(4), context);
    return { args, body };
  }
  
  static getApplicationData(tsNode, context) {
    const func = new Node(tsNode.child(0), context);
    const params = Node.getList(tsNode.child(2)).map((n) => new Node(n, context));
    return { func, params };
  }
  
  static getList(tsNode) {
    const elem = [tsNode.child(0)];
    const comma = tsNode.child(1);
    return comma ? elem.concat(Node.getList(tsNode.child(2))) : elem;
  }
}

module.exports = Node;
