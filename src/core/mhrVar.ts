import MhrType from 'core/mhrType';

export default class MhrVar {

  static count: number;

  name: string;
  realName: string;
  type: MhrType;
  index: number;

  constructor(name: string, type: MhrType) {
    this.name = name;
    this.type = type;
    this.realName = MhrVar.generateRealName();
  }

  hasType(): boolean {
    return this.type !== undefined;
  }

  getType(): MhrType {
    return this.type;
  }

  setIndex(index: number): void {
    this.index = index;
  }

  static generateRealName(): string {
    return `var_${this.count++}`;
  }
}

MhrVar.count = 0;
