const PREFIX = 'expr_';

class MhrNode {
  constructor(node) {
    Object.keys(node).forEach((key) => this[key] = node[key]);
  }
  
  match(options) {
    const option = options[this.type] || options['_'];
    return option && option(this);
  }
  
  static parse(tsNode, fileContext) {
    
    // Get the node with real meaning
    const node = MhrNode.getRealNode(tsNode);
    const type = node.type.substring(PREFIX.length);
    
    // Get data and copy all things to self
    const data = MhrNode.getData(node, fileContext);
    return new MhrNode({ type, ...data });
  }
  
  static getRealNode(tsNode) {
    const { type } = tsNode;
    if (type.indexOf(PREFIX) === 0) {
      return tsNode;
    } else {
      const childIndex = type === 'paren_expr' ? 1 : 0;
      return MhrNode.getRealNode(tsNode.child(childIndex));
    }
  }
  
  static getData(tsNode, fileContext) {
    const { type } = tsNode;
    return MhrNode.getDataGetter(type)(tsNode, fileContext);
  }
  
  static getDataGetter(type) {
    switch (type) {
      case 'expr_int': return MhrNode.getIntData;
      case 'expr_var': return MhrNode.getVarData;
      case 'expr_bin_op': return MhrNode.getBinOpData;
      case 'expr_let': return MhrNode.getLetData;
      case 'expr_function': return MhrNode.getFunctionData;
      case 'expr_application': return MhrNode.getApplicationData;
      default: throw new Error(`Not implemented type ${type}`);
    }
  }
  
  static getIntData(tsNode, fileContext) {
    const integerNode = tsNode.child(0);
    const integerStr = fileContext.get(integerNode);
    const value = parseInt(integerStr);
    return { value };
  }
  
  static getVarData(tsNode, fileContext) {
    const identifierNode = tsNode.child(0);
    const name = fileContext.get(identifierNode);
    return { name };
  }
  
  static getBinOpData(tsNode, fileContext) {
    const e1 = MhrNode.parse(tsNode.child(0), fileContext);
    const op = tsNode.child(1).type;
    const e2 = MhrNode.parse(tsNode.child(2), fileContext);
    return { op, e1, e2 };
  }
  
  static getLetData(tsNode, fileContext) {
    const name = fileContext.get(tsNode.child(1));
    const binding = MhrNode.parse(tsNode.child(3), fileContext);
    const expr = MhrNode.parse(tsNode.child(5), fileContext);
    return { name, binding, expr };
  }
  
  static getFunctionData(tsNode, fileContext) {
    const args = MhrNode.getList(tsNode.child(1)).map((n) => fileContext.get(n));
    const body = MhrNode.parse(tsNode.child(4), fileContext);
    return { args, body };
  }
  
  static getApplicationData(tsNode, fileContext) {
    const callee = MhrNode.parse(tsNode.child(0), fileContext);
    const params = MhrNode.getList(tsNode.child(2)).map((n) => MhrNode.parse(n, fileContext));
    return { callee, params };
  }
  
  static getList(tsNode) {
    const elem = [tsNode.child(0)];
    const comma = tsNode.child(1);
    return comma ? elem.concat(MhrNode.getList(tsNode.child(2))) : elem;
  }
}

module.exports = MhrNode;
