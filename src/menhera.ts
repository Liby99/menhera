import MhrContext from 'core/mhrContext';
import * as util from 'util';

((filename: string): void => {
  const context = new MhrContext(filename);

  console.log(util.inspect(context.functions, false, null, true /* enable colors */));
})(process.argv[2]);
