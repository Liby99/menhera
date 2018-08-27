const Parser = require('./parser/parser');
const ast = Parser.parse('((a, b) => a + b - 1)(3, 5)');
console.log(JSON.stringify(ast));
