const fs = require('fs');
const path = require('path');
const Parser = require('parser/parser');
const Preprocessor = require('preprocessor/preprocessor');
const MhrFunction = require('core/mhrFunction');

class MhrContext {
  constructor(filename) {
    
    // Initializing
    this.filename = path.join(process.cwd(), filename);
    this.file = fs.readFileSync(this.filename, 'utf-8');
    
    // Parse
    this.ast = Parser.parse(this.file);
    
    // Preprocessing - get main expression and functions
    this.functions = Preprocessor.extractFunctions(this.ast);
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
  
  getFunctions() {
    return this.functions;
  }
}

module.exports = MhrContext;
