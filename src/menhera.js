const Parser = require('./parser/parser');
const ast = Parser.parse('let x = 3 in 1 + x');
console.log(JSON.stringify(ast));
