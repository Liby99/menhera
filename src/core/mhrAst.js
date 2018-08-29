const MhrNode = require('core/MhrNode');

class MhrAst {
  constructor(tsTree, fileContext) {
    this.tsTree = tsTree;
    this.root = new MhrNode(tsTree.rootNode, fileContext);
  }
  
  getRoot() {
    return this.root;
  }
}

module.exports = MhrAst;
