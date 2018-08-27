const Parser = require('./parser/parser');
const ast = Parser.parse('1 + 2 + 3');
console.log(JSON.stringify(ast));
