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

  equals(other: MhrType): boolean {
    return false;
  }

  toString(): string {
    return '';
  }
}

export class MhrUnitType extends MhrType {
  name: string;
  constructor(name: string) {
    super('unit');
    this.name = name;
  }

  equals(other: MhrType): boolean {
    if (other.type === 'unit') {
      const otherUnitType = <MhrUnitType> other;
      return this.name === otherUnitType.name;
    } else {
      return false;
    }
  }

  toString(): string {
    return this.name;
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

  equals(other: MhrType): boolean {
    if (other.type === 'closure') {
      const otherClosureType = <MhrClosureType> other;
      return this.args.reduce((equal, arg, argIndex) => {
        return equal && arg.equals(otherClosureType.args[argIndex]);
      }, this.ret.equals(otherClosureType.ret));
    } else {
      return false;
    }
  }

  toString(): string {
    return `(${this.args.map(arg => arg.toString()).join(', ')}) -> ${this.ret}`;
  }
}

export class MhrTempType extends MhrType {
  static count: number = 0;
  id: number;
  constructor() {
    super('temp');
    this.id = ++MhrTempType.count;
  }

  equals(other: MhrType): boolean {
    if (other.type === 'temp') {
      const otherTempType = <MhrTempType> other;
      return this.id === otherTempType.id;
    } else {
      return false;
    }
  }

  toString(): string {
    return `τ${this.id}`;
  }
}