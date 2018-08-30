import MhrContext from 'core/mhrContext';

((filename: string): void => {
  const context = new MhrContext(filename);
  console.log(context.getFunctions());
})(process.argv[2]);
