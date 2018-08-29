const TreeSitter = require('tree-sitter');
const TreeSitterMenhera = require('tree-sitter-menhera');
const FileContext = require('parser/fileContext');
const MhrAst = require('core/mhrAst');

class Parser {
  static parse(file) {
    
    // Setup tree-sitter parser and Use tree-sitter parser to parse the file
    const TreeSitterParser = new TreeSitter();
    TreeSitterParser.setLanguage(TreeSitterMenhera);
    const tsTree = TreeSitterParser.parse(file);
    
    // Further process the file to get the real AST
    const fileContext = new FileContext(file);
    return new MhrAst(tsTree, fileContext);
  }
}

module.exports = Parser;
