const MhrNode = require('core/MhrNode');

class MhrAst {
  constructor(tsTree, fileContext) {
    const { rootNode } = tsTree;
    this.tsTree = tsTree;
    this.mhrNode = new MhrNode(rootNode, fileContext);
  }
}

module.exports = MhrAst;
