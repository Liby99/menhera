import MhrNode from 'core/mhrNode';

export default class MhrAst {
  
  rootNode: MhrNode;
  
  constructor(rootNode: MhrNode) {
    this.rootNode = rootNode;
  }
  
  getRootNode(): MhrNode {
    return this.rootNode;
  }
}
