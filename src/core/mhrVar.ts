import MhrType from 'core/mhrType';

export default class MhrVar {

  static count: number;

  name: string;
  realName: string;
  type: MhrType;
  index: number;

  constructor(name, type) {
    this.name = name;
    this.type = type;
    this.realName = MhrVar.generateRealName();
  }

  hasType() {
    return this.type !== undefined;
  }

  getType() {
    return this.type;
  }

  setIndex(index: number) {
    this.index = index;
  }

  static generateRealName(): string {
    return `var_${this.count++}`;
  }
}

MhrVar.count = 0;
