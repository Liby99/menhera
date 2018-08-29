const fs = require('fs');
const path = require('path');
const Parser = require('parser/parser');
const Preprocessor = require('preprocessor/preprocessor');

class MhrContext {
  constructor(filename) {
    
    // Initializing
    this.filename = path.join(process.cwd(), filename);
    this.file = fs.readFileSync(this.filename, 'utf-8');
    
    // Parse
    this.ast = Parser.parse(this.file);
    
    // Preprocessing
    const { mainExpr, functions } = Preprocessor.extractFunctions(this.ast);
    this.mainExpr = mainExpr;
    this.functions = functions;
  }
  
  getFileName() {
    return this.filename;
  }
  
  getFile() {
    return this.file;
  }
  
  getAst() {
    return this.ast;
  }
  
  getMainExpr() {
    return this.mainExpr;
  }
  
  getFunctions() {
    return this.functions;
  }
}

module.exports = MhrContext;
