const Parser = require('tree-sitter');
const MenheraGrammar = require('tree-sitter-menhera');

const parser = new Parser();
parser.setLanguage(MenheraGrammar);

const ast = parser.parse('((a, b) => (c) => a + b + c)(1, 2)(3)');
console.log(ast.rootNode.child(0).child(0).child(0).child(2).child(0).child(0).child(0).child(0))
