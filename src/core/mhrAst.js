class MhrAst {
  constructor(tsTree, rootNode) {
    this.tsTree = tsTree;
    this.rootNode = rootNode;
  }
  
  getRootNode() {
    return this.rootNode;
  }
}

module.exports = MhrAst;
