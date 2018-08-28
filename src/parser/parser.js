const TreeSitter = require('tree-sitter');
const TreeSitterMenhera = require('tree-sitter-menhera');
const Context = require('./context');
const Node = require('./node');

module.exports = {
  
  parse(file) {
    
    // Setup tree-sitter parser
    const TreeSitterParser = new TreeSitter();
    TreeSitterParser.setLanguage(TreeSitterMenhera);
    
    // Use tree-sitter parser to parse the file
    const tsTree = TreeSitterParser.parse(file);
    const tsRootNode = tsTree.rootNode;
    
    // Further process the file to get the real AST
    const context = new Context(file);
    return new Node(tsRootNode, context);
  }
}
