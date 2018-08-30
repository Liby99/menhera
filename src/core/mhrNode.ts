import MhrType from './mhrType';

class MhrNode {
  
  type: string;
  exprType: MhrType;
  [props: string]: any;
  
  constructor(node) {
    Object.keys(node).forEach((key) => this[key] = node[key]);
  }
  
  setExprType(exprType) {
    this.exprType = exprType;
    return exprType;
  }
  
  match(options) {
    const option = options[this.type] || options['_'];
    return option && option(this);
  }
}

export default MhrNode;
