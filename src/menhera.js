const MhrContext = require('core/mhrContext');

function main(filename) {
  const context = new MhrContext(filename);
  console.log(context.getMainExpr());
  console.log(context.getFunctions());
}

main(process.argv[2]);
