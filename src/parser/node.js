class Node {
  constructor(tsNode, context) {
    
    // Get the node which has real meaning
    const node = Node.getRealNode(tsNode);
    
    // Generate node by giving value to type and data
    this.type = node.type;
    this.data = Node.getData(node, context);
  }
  
  static getRealNode(tsNode) {
    return tsNode.type.indexOf('expr_') === 0 ? tsNode : Node.getRealNode(tsNode.child(0));
  }
  
  static getData(tsNode, context) {
    const { type } = tsNode;
    switch (type) {
      case 'expr_int': return Node.getIntData(tsNode, context);
      case 'expr_var': return Node.getVarData(tsNode, context);
      case 'expr_bin_op': return Node.getBinOpData(tsNode, context);
      case 'expr_let': return Node.getLetData(tsNode, context);
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
    const e1 = tsNode.child(0);
    const op = tsNode.child(1).type;
    const e2 = tsNode.child(2);
    return {
      op: op,
      e1: new Node(e1, context),
      e2: new Node(e2, context)
    };
  }
  
  static getLetData(tsNode, context) {
    const name = context.get(tsNode.child(1));
    const binding = tsNode.child(3);
    const expr = tsNode.child(5);
    return {
      name: name,
      binding: new Node(binding, context),
      expr: new Node(expr, context)
    };
  }
}

module.exports = Node;
