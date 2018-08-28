const Parser = require('./parser/parser');
const Compiler = require('./compiler/compiler');
const ast = Parser.parse('((a) => (b) => a + b)(1)(2)');
const { functions, main } = Compiler.extractFunctions(ast);
console.log('functions: ');
console.log(JSON.stringify(functions));
console.log('main: ');
console.log(JSON.stringify(main));
