import MhrNode from './mhrNode';

class MhrAst {
  
  rootNode: MhrNode;
  
  constructor(rootNode: MhrNode) {
    this.rootNode = rootNode;
  }
  
  getRootNode(): MhrNode {
    return this.rootNode;
  }
}

export default MhrAst;
