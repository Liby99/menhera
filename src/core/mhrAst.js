const MhrNode = require('core/MhrNode');

class MhrAst {
  constructor(tsTree, rootNode) {
    this.tsTree = tsTree;
    this.rootNode = rootNode;
  }
  
  getRootNode() {
    return this.rootNode;
  }
  
  static parse(tsTree, fileContext) {
    const rootNode = MhrNode.parse(tsTree.rootNode, fileContext);
    return new MhrAst(tsTree, rootNode);
  }
}

module.exports = MhrAst;
