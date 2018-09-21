type MhrTypeType =
  | 'unit'
  | 'closure'
  | 'temp';
  
type MhrTypeOptions<T> = {
  [type in MhrTypeType]?: (type: MhrType) => T
};

export default class MhrType {
  type: MhrTypeType;
  
  constructor(type: MhrTypeType) {
    this.type = type;
  }
  
  match<T>(options: MhrTypeOptions<T>): T {
    const option = options[this.type];
    if (option) {
      return option(this);
    } else {
      throw new Error(`Unmatched option ${this.type}`);
    }
  }
}

export class MhrUnitType extends MhrType {
  name: string;
  constructor(name: string) {
    super('unit');
    this.name = name;
  }
}

export class MhrClosureType extends MhrType {
  ret: MhrType;
  args: Array<MhrType>;
  constructor(ret: MhrType, args: Array<MhrType>) {
    super('closure');
    this.ret = ret;
    this.args = args;
  }
}
