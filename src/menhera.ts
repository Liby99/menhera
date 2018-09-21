import MhrContext from 'core/mhrContext';
import print from 'utility/print';
import compile from 'compiler/compile';

((filename: string): void => {
  const context = new MhrContext(filename);
  // print(context.functions);
  compile(context);
})(process.argv[2]);
