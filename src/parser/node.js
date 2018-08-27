class Node {
  constructor(tsNode, context) {
    const node = Node.getRealNode(tsNode);
    this.type = node.type;
    this.data = Node.getData(node, context);
  }
  
  static getRealNode(tsNode) {
    const { type } = tsNode;
    if (type.indexOf('expr_') === 0) {
      return tsNode;
    } else {
      return Node.getRealNode(tsNode.child(0));
    }
  }
  
  static getData(tsNode, context) {
    const { type } = tsNode;
    switch (type) {
      case 'expr_int': return Node.getIntData(tsNode, context);
      case 'expr_bin_op': return Node.getBinOpData(tsNode, context);
      default: throw new Error(`Not implemented type ${type}`);
    }
  }
  
  static getIntData(tsNode, context) {
    const integerNode = tsNode.child(0);
    const integerStr = context.get(integerNode);
    const integer = parseInt(integerStr);
    return integer;
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
}

module.exports = Node;
