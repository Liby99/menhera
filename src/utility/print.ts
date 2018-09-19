import * as util from 'util';

export default function print(obj) {
  console.log(util.inspect(obj, false, null, true));
}
