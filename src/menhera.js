const Parser = require('parser/parser');
const Preprocessor = require('preprocessor/preprocessor');

function main(content) {
  const ast = Parser.parse(content);
  const { mainExpr, functions } = Preprocessor.extractFunctions(ast);
  console.log(mainExpr);
  console.log(functions);
}

main('((a) => (b) => a + b)(1)(2)');
