import MhrContext from 'core/mhrContext';
import print from 'utility/print';

((filename: string): void => {
  const context = new MhrContext(filename);
  print(context.functions);
})(process.argv[2]);
