import MhrContext from 'core/mhrContext';
import compile from 'compiler/compile';

((filename: string): void => {
  const context = new MhrContext(filename);
  compile(context);
})(process.argv[2]);
