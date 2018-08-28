const Parser = require('./parser/parser');
const ast = Parser.parse('((a) => (b) => a + b)(1)(2)');
const Func = require('./compiler/func');
Func.extract(ast);
